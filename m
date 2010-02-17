From: Miguel F Mascarenhas Sousa Filipe <miguel.filipe@gmail.com>
Subject: Fwd: btrfs-tools backport for Debian Lenny
Date: Wed, 17 Feb 2010 17:22:48 +0000
Message-ID: <f058a9c31002170922y2566427dpd5006c1c0298a444@mail.gmail.com>
References: <201002171632.38310.ms@teamix.de>
	 <f058a9c31002170921p37f00b83m1e9c9b91bacb54a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c31002170921p37f00b83m1e9c9b91bacb54a8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 17, 2010 at 3:32 PM, Martin Steigerwald <ms@teamix.de> wrot=
e:
>
> Cc'd backports-users mailing list, cc'd package maintainer Daniel Bau=
mann as
> well.
>
>
> Hi!
>
> JFYI - most of you might prefer to run btrfs-tools from git -, I made=
 a
> btrfs-tools 0.19 backport for Debian Lenny from the package in Debian=
 Squeeze
> and put it online at:
>
> http://people.teamix.net/~ms/debian/lenny-backports/btrfs-tools/
>
> You can find discussion on sponsoring it here:
>
> http://lists.backports.org/lurker-bpo/thread/20100217.143508.41736c9f=
=2Een.html
>
> I think it won't work with the latest backports 2.6.30 kernel due to =
btrfs
> format changes, I test it with a self compiled 2.6.32.3. A 2.6.32 for
> backports org should be due soon and then my btrfs-tools backport mig=
ht
> appear in the bpo archive as well.
>
> It basically works, but I am wondering it the RAID options work corre=
ctly. I
> used:
>
> mkfs.btrfs -d raid1 -m
> raid1 /dev/mango1/homelokal1 /dev/mango2/homelokal2
>
> on two 200 GiB logical volumes and get
>
> mango:~# df -hT /mnt/zeit
> Dateisystem =C2=A0 Typ =C2=A0 =C2=A0Gr=C3=B6=C3=9Fe Benut =C2=A0Verf =
Ben% Eingeh=C3=A4ngt auf
> /dev/mapper/mango1-homelokal1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs =C2=A0 =C2=A0400G =C2=
=A0101M =C2=A0400G =C2=A0 1% /mnt/zeit
>
> Shouldn't that be 200GiB for a BTRFS Raid 1 setup?
>


this has been discussed several times on the list.
Since btrfs file level redundancy policy, the proper way for it to
behave is to show full physical capacity of the devices.
Usage will be correctly accounted, so if you write a 100MB file in
that raid1 FS tree
the used space will indicate 200MB of additional used space.
Regards,




--
Miguel Sousa Filipe
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
