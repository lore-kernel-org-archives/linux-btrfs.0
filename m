From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Mon, 27 Jun 2011 17:04:43 -0400
Message-ID: <4E08F06B.9020106@redhat.com>
References: <1309197745-14107-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309197745-14107-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/27/2011 02:02 PM, Josef Bacik wrote:
> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
> using fiemap in things like cp cause more problems than it solves, so lets try
> and give userspace an interface that doesn't suck.  We need to match solaris
> here, and the definitions are
> 
> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
> next hole greater than or equal to the supplied offset
> is returned. The definition of a hole is provided near
> the end of the DESCRIPTION.
> 
> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
> start of the next non-hole file region greater than or
> equal to the supplied offset.
> 
> So in the generic case the entire file is data and there is a virtual hole at
> the end.  That means we will just return i_size for SEEK_HOLE and will return
> the same offset for SEEK_DATA.  This is how Solaris does it so we have to do it
> the same way.
> 
> Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/read_write.c    |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |    4 +++-
>  2 files changed, 40 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 5520f8a..d58551e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -64,6 +64,23 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
>  			return file->f_pos;
>  		offset += file->f_pos;
>  		break;
> +	case SEEK_DATA:
> +		/*
> +		 * In the generic case the entire file is data, so as long as
> +		 * offset isn't at the end of the file then the offset is data.
> +		 */
> +		if (offset >= inode->i_size)
> +			return -ENXIO;
> +		break;
> +	case SEEK_HOLE:
> +		/*
> +		 * There is a virtual hole at the end of the file, so as long as
> +		 * offset isn't i_size or larger, return i_size.
> +		 */
> +		if (offset >= inode->i_size)
> +			return -ENXIO;
> +		offset = inode->i_size;
> +		break;
>  	}
>  
>  	if (offset < 0 && !unsigned_offsets(file))
> @@ -141,6 +158,26 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
>  				goto out;
>  			}
>  			offset += file->f_pos;
> +			break;
> +		case SEEK_DATA:
> +			/*
> +			 * In the generic case the entire file is data, so as
> +			 * long as offset isn't at the end of the file then the
> +			 * offset is data.
> +			 */
> +			if (offset >= inode->i_size)
> +				return -ENXIO;
> +			break;
> +		case SEEK_HOLE:
> +			/*
> +			 * There is a virtual hole at the end of the file, so
> +			 * as long as offset isn't i_size or larger, return
> +			 * i_size.
> +			 */
> +			if (offset >= inode->i_size)
> +				return -ENXIO;
> +			offset = inode->i_size;
> +			break;

Hrm sorry I just noticed this doesn't compile.  I'll fix it up and
resend along with the xfstest update that Andreas pointed out.  Thanks,

Josef
