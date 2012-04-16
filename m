From: "Sergey V." <sftp.mtuci@gmail.com>
Subject: Re: [btrfs-progs: PATCH 2/2] Makefile: use $(MAKE) instead of hardcoded 'make'
Date: Mon, 16 Apr 2012 15:50:13 +0400
Message-ID: <201204161550.13859.sftp.mtuci@gmail.com>
References: <1333372202-627-1-git-send-email-slyich@gmail.com> <1333372202-627-2-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333372202-627-2-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 02 of April 2012 17:10:02 Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> CC: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  Makefile |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ebfd5c8..9694444 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -101,15 +101,15 @@ ioctl-test: $(objects) ioctl-test.o
>  	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
>  
>  manpages:
> -	cd man; make
> +	cd man; $(MAKE)
>  
>  install-man:
> -	cd man; make install
> +	cd man; $(MAKE) install
>  
>  clean :
>  	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
>  	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
> -	cd man; make clean
> +	cd man; $(MAKE) clean
>  
>  install: $(progs) install-man
>  	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> -- 

Resonable.

Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>

for both patches.

Thanks
