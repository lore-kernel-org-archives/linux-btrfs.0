From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 11:09:34 -0700
Message-ID: <201105051109.35152.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <20110504095153.GA6914@attic.humilis.net> <201105050749.09690.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105050749.09690.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


Anyone have a suggestion?

Also on another machine set up similarly, I now cannot mkdir.  It says 'no space left on device'.  df says:
# df /dev/sdb
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb             3907029168 2658010524 1246486516  69% /home

sdb and sdc are one btrfs 'raid' volume.  What could be wrong?


On Thursday 5 May, 2011 07:49:09 CACook@quantum-sci.com wrote:
> On Wednesday 4 May, 2011 02:51:54 Sander wrote:
> > Put an exit on top of /etc/kernel/postrm.d/zz-update-grub and try again.
> > 
> > Install grub-pc 1.99~rc1-13 from Sid.
> 
> First I put an exit right after #! /bin/sh  and it failed.  Then I moved /etc/kernel/postrm.d/zz-update-grub to / and it still failed.
> 
> Grub is not running as a daemon, so I shouldn't have to reboot for the new version to take effect.  And frankly at the moment I'm afraid to reboot, with only grub-common installed.
> 
> # dpkg -i /var/cache/apt/archives/grub-common_1.99~rc1-13_amd64.deb 
> (Reading database ... 136689 files and directories currently installed.)
> Preparing to replace grub-common 1.98+20100804-14 (using .../grub-common_1.99~rc1-13_amd64.deb) ...
> Unpacking replacement grub-common ...
> Setting up grub-common (1.99~rc1-13) ...
> Installing new version of config file /etc/grub.d/10_linux ...
> Installing new version of config file /etc/grub.d/30_os-prober ...
> Installing new version of config file /etc/grub.d/00_header ...
> Installing new version of config file /etc/grub.d/20_linux_xen ...
> Processing triggers for install-info ...
> Processing triggers for man-db ...
> 
> # dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb 
> (Reading database ... 136703 files and directories currently installed.)
> Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-13_amd64.deb) ...
> Unpacking replacement grub-pc ...
> Setting up grub-pc (1.99~rc1-13) ...
> grub-probe: error: cannot stat `/dev/root'.
> Installation finished. No error reported.
> /usr/sbin/grub-probe: error: cannot stat `/dev/root'.
> dpkg: error processing grub-pc (--install):
>  subprocess installed post-installation script returned error exit status 1
> Processing triggers for man-db ...
> Errors were encountered while processing:
>  grub-pc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
