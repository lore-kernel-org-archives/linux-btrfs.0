From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 08:15:25 -0700
Message-ID: <201105060815.26395.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105060753.03469.CACook@quantum-sci.com> <20110506145847.GA16132@attic.humilis.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110506145847.GA16132@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 6 May, 2011 07:58:47 you wrote:
> Say 'yes', try to finish your upgrade.

Now when I ran it, it went as normal for some reason.
 
> Then:
> grub-install /dev/sda
Auto-detection of a filesystem of  failed.
Please report this together with the output of "/usr/sbin/grub-probe --device-map="/boot/grub/device.map" --target=fs -v /boot/grub" to <bug-grub@gnu.org>


> update-grub
Generating grub.cfg ...
Found background image: /usr/share/images/desktop-base/desktop-grub.png
Found linux image: /boot/vmlinuz-2.6.38-2-amd64
Found initrd image: /boot/initrd.img-2.6.38-2-amd64
Found linux image: /boot/vmlinuz-2.6.37-2
Found Windows XP Pro on /dev/sda4
done

I'm afraid to reboot though, because yesterday I started a btrfs fi balance on this machine while sshed to another, and that is still running 15 hours later with no indication of progress nor sign of abating.  ^C is ineffective.





