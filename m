From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Mon, 27 Jun 2011 14:47:22 -0400
Message-ID: <4E08D03A.5050304@redhat.com>
References: <1309197745-14107-1-git-send-email-josef@redhat.com> <1309197745-14107-5-git-send-email-josef@redhat.com> <C411BFA0-3C52-461E-8C15-3EE3F076AE71@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <C411BFA0-3C52-461E-8C15-3EE3F076AE71@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/27/2011 02:32 PM, Andreas Dilger wrote:
> On 2011-06-27, at 12:02 PM, Josef Bacik wrote:

<snip>

>> +
>> +#define SEEK_DATA	3
>> +#define SEEK_HOLE	4
> 
> These should probably be "#ifndef SEEK_DATA" so that gcc doesn't complain
> in the future when these are added to a standard header.
> 

Good point, I will fix that, thanks.

<snip>

>> +
>> +	pos = lseek(fd, 0, SEEK_HOLE);
>> +	if (pos == alloc_size * 2) {
>> +		if (!(flags & QUIET))
>> +			printf("File system does not recognize holes, the only "
>> +			       "hole found will be at the end.\n");
>> +		flags |= FS_NO_HOLES;
> 
> This is a question that I've also had about compatibility with older
> (well, every) Linux kernel that does not support SEEK_{HOLE,DATA}
> today.
> 

If you look at the xfstest part of it, I grep for a complaint about not
support SEEK_HOLE and I just say _notrun.  I ran this test on an old
kernel and it just skipped the test.

> My reading of the existing generic_file_llseek() and default_llseek()
> code, along with most filesystem-specific llseek() implementations is
> that they will happily ignore the @whence parameter if it is not
> known, and pretend like it is 0 (SEEK_SET), so they will just set the
> position to the @offset parameter and return this value.  In that
> case, the above "SEEK_HOLE" test would incorrectly fail on every
> Linux kernel in existence today because the returned pos == 0.
> 

First, older kernels will check for whence > SEEK_MAX and automatically
return -EINVAL, so we are ok there.

Second, I looked at everybody in fs/ and changed anybody that did what
you suggest.  Anybody that I didn't change will return -EINVAL properly
so I didn't touch them.  I also looked at the drivers that didn't use
default_llseek/seq_lseek or whatever and they all seem to handle things
properly, though I'm sure I missed somebody.

> Should applications call both SEEK_HOLE and SEEK_DATA with @offset=0,
> and if they return the same values (which is normally impossible,
> decide that the kernel does not support this SEEK_* functionality?

Yeah if you want to be super careful.  I mean for all file systems we
should be ok with my patches, but if you hit some weird proc file that
has it's llseek thing tied to something specific in the driver you may
run into trouble, and by trouble you will just get weird return's for
your seek.  Thanks,

Josef

