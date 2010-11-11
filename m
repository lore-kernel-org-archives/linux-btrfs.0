From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Wed, 10 Nov 2010 21:10:34 -0500
Message-ID: <20101111021034.GA6911@dhcp231-156.rdu.redhat.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 10, 2010 at 12:02:18PM -0600, Mitch Harder wrote:
> Update the mkfs.btrfs man page for the -M option to mix data and
> metadata chunks.
> 
> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> ---
>  man/mkfs.btrfs.8.in |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
> index 1e14c6c..c23dddc 100644
> --- a/man/mkfs.btrfs.8.in
> +++ b/man/mkfs.btrfs.8.in
> @@ -9,6 +9,7 @@ mkfs.btrfs \- create an btrfs filesystem
>  [ \fB \-l\fP\fI leafsize\fP ]
>  [ \fB \-L\fP\fI label\fP ]
>  [ \fB \-m\fP\fI metadata profile\fP ]
> +[ \fB \-M\fP\fI mixed data+metadata\fP ]
>  [ \fB \-n\fP\fI nodesize\fP ]
>  [ \fB \-s\fP\fI sectorsize\fP ]
>  [ \fB \-h\fP ]
> @@ -45,6 +46,10 @@ Specify a label for the filesystem.
>  Specify how metadata must be spanned across the devices specified. Valid
>  values are raid0, raid1, raid10 or single.
>  .TP
> +\fB\-M\fR, \fB\-\-mixed\fR
> +Mix data and metadata chunks together for more efficient space 
> +utilization.
> +.TP
>  \fB\-n\fR, \fB\-\-nodesize \fIsize\fR
>  Specify the nodesize. By default the value is set to the pagesize.
>  .TP
> -- 
> 1.7.2.2

Let's mention that it's for smaller filesystems since it has a significant
performance impact when using mixed block groups on larger filesystems.  Thanks,

Josef
