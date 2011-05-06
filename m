From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 07:53:01 -0700
Message-ID: <201105060753.03469.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105060656.12544.CACook@quantum-sci.com> <20110506141659.GA1804@attic.humilis.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110506141659.GA1804@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 6 May, 2011 07:17:00 you wrote:
> Hm. Just do cp /bin/true /usr/sbin/grub-probe

Yikes, it came up with an ncurses screen saying:

GRUB failed to install to the following devices:                       =
              =E2=94=82  =20
  =E2=94=82                                                            =
                          =E2=94=82  =20
  =E2=94=82 /dev/sda                                                   =
                          =E2=94=82  =20
  =E2=94=82                                                            =
                          =E2=94=82  =20
  =E2=94=82 Do you want to continue anyway? If you do, your computer ma=
y not start up properly.  =E2=94=82  =20
  =E2=94=82                                                            =
                          =E2=94=82  =20
  =E2=94=82 Writing GRUB to boot device failed - continue?             =
                          =E2=94=82  =20
  =E2=94=82                                                            =
                          =E2=94=82  =20
  =E2=94=82                        <Yes>                           <No>=
                          =E2=94=82  =20
  =E2=94=82                                                            =
=20

Say No and another ncurses screen saying:
The grub-pc package is being upgraded. This menu allows you to select w=
hich devices    =E2=94=82 =20
 =E2=94=82 you'd like grub-install to be automatically run for, if any.=
                           =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82 Running grub-install automatically is recommended in most si=
tuations, to prevent the   =E2=94=82 =20
 =E2=94=82 installed GRUB core image from getting out of sync with GRUB=
 modules or grub.cfg.      =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82 If you're unsure which drive is designated as boot drive by =
your BIOS, it is often a   =E2=94=82 =20
 =E2=94=82 good idea to install GRUB to all of them.                   =
                           =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82 Note: it is possible to install GRUB to partition boot recor=
ds as well, and some       =E2=94=82 =20
 =E2=94=82 appropriate partitions are offered here. However, this force=
s GRUB to use the          =E2=94=82 =20
 =E2=94=82 blocklist mechanism, which makes it less reliable, and there=
fore is not recommended.   =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82 GRUB install devices:                                       =
                           =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82    [*] /dev/sda (750156 MB; WDC_WD7500BPKT-00PK4T0)         =
                           =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82                                                             =
                           =E2=94=82 =20
 =E2=94=82                                         <Ok>=20

So I canceled out of it, not knowing WTH.  I don't understand why the n=
ewer grub still doesn't understand BTRFS?

# cp /bin/true /usr/sbin/grub-probe
# dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
(Reading database ... 135273 files and directories currently installed.=
)
Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-13=
_amd64.deb) ...
Unpacking replacement grub-pc ...
Setting up grub-pc (1.99~rc1-13) ...
Auto-detection of a filesystem of  failed.
Please report this together with the output of "/usr/sbin/grub-probe --=
device-map=3D"/boot/grub/device.map" --target=3Dfs -v /boot/grub" to <b=
ug-grub@gnu.org>
^[Auto-detection of a filesystem of  failed.
Please report this together with the output of "/usr/sbin/grub-probe --=
device-map=3D"/boot/grub/device.map" --target=3Dfs -v /boot/grub" to <b=
ug-grub@gnu.org>
Auto-detection of a filesystem of  failed.
Please report this together with the output of "/usr/sbin/grub-probe --=
device-map=3D"/boot/grub/device.map" --target=3Dfs -v /boot/grub" to <b=
ug-grub@gnu.org>
Generating grub.cfg ...
=46ound background image: /usr/share/images/desktop-base/desktop-grub.p=
ng
=46ound linux image: /boot/vmlinuz-2.6.38-2-amd64
=46ound initrd image: /boot/initrd.img-2.6.38-2-amd64
=46ound linux image: /boot/vmlinuz-2.6.37-2
=46ound Windows XP Pro on /dev/sda4
done
Processing triggers for man-db ...
#/usr/sbin/grub-probe --device-map=3D"/boot/grub/device.map" --target=3D=
fs -v /boot/grub
#



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
