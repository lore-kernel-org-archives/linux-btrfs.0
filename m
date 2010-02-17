From: Miguel F Mascarenhas Sousa Filipe <miguel.filipe@gmail.com>
Subject: Re: btrfs-tools backport for Debian Lenny
Date: Wed, 17 Feb 2010 17:21:57 +0000
Message-ID: <f058a9c31002170921p37f00b83m1e9c9b91bacb54a8@mail.gmail.com>
References: <201002171632.38310.ms@teamix.de>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=00032555bd7e6122b4047fcf1662
Cc: Daniel Baumann <daniel@debian.org>, backports-users@lists.backports.org,
	linux-btrfs@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Return-path: <backports-users-bounces@lists.backports.org>
In-Reply-To: <201002171632.38310.ms@teamix.de>
List-Unsubscribe: <http://lists.backports.org/mailman/listinfo/backports-users>,
	<mailto:backports-users-request@lists.backports.org?subject=unsubscribe>
List-Archive: <http://lists.backports.org/lurker/list/backports-users.html>
List-Post: <mailto:backports-users@lists.backports.org>
List-Help: <mailto:backports-users-request@lists.backports.org?subject=help>
List-Subscribe: <http://lists.backports.org/mailman/listinfo/backports-users>,
	<mailto:backports-users-request@lists.backports.org?subject=subscribe>
Errors-To: backports-users-bounces@lists.backports.org
List-ID: <linux-btrfs.vger.kernel.org>

--00032555bd7e6122b4047fcf1662
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 17, 2010 at 3:32 PM, Martin Steigerwald <ms@teamix.de> wrote:

> Cc'd backports-users mailing list, cc'd package maintainer Daniel Baumann
> as
> well.
>
>
> Hi!
>
> JFYI - most of you might prefer to run btrfs-tools from git -, I made a
> btrfs-tools 0.19 backport for Debian Lenny from the package in Debian
> Squeeze
> and put it online at:
>
> http://people.teamix.net/~ms/debian/lenny-backports/btrfs-tools/
>
> You can find discussion on sponsoring it here:
>
>
> http://lists.backports.org/lurker-bpo/thread/20100217.143508.41736c9f.en.=
html
>
> I think it won't work with the latest backports 2.6.30 kernel due to btrf=
s
> format changes, I test it with a self compiled 2.6.32.3. A 2.6.32 for
> backports org should be due soon and then my btrfs-tools backport might
> appear in the bpo archive as well.
>
> It basically works, but I am wondering it the RAID options work correctly=
.
> I
> used:
>
> mkfs.btrfs -d raid1 -m
> raid1 /dev/mango1/homelokal1 /dev/mango2/homelokal2
>
> on two 200 GiB logical volumes and get
>
> mango:~# df -hT /mnt/zeit
> Dateisystem   Typ    Gr=C3=B6=C3=9Fe Benut  Verf Ben% Eingeh=C3=A4ngt auf
> /dev/mapper/mango1-homelokal1
>             btrfs    400G  101M  400G   1% /mnt/zeit
>
> Shouldn't that be 200GiB for a BTRFS Raid 1 setup?
>
>

this has been discussed several times on the list.

Since btrfs file level redundancy policy, the proper way for it to behave i=
s
to show full physical capacity of the devices.

Usage will be correctly accounted, so if you write a 100MB file in that
raid1 FS tree
the used space will indicate 200MB of additional used space.

Regards,



> Ciao,
> --
> Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
> gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
>



--=20
Miguel Sousa Filipe

--00032555bd7e6122b4047fcf1662
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Wed, Feb 17, 2010 at 3:32 PM, Martin =
Steigerwald <span dir=3D"ltr">&lt;<a href=3D"mailto:ms@teamix.de">ms@teamix=
.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
Cc&#39;d backports-users mailing list, cc&#39;d package maintainer Daniel B=
aumann as<br>
well.<br>
<br>
<br>
Hi!<br>
<br>
JFYI - most of you might prefer to run btrfs-tools from git -, I made a<br>
btrfs-tools 0.19 backport for Debian Lenny from the package in Debian Squee=
ze<br>
and put it online at:<br>
<br>
<a href=3D"http://people.teamix.net/~ms/debian/lenny-backports/btrfs-tools/=
" target=3D"_blank">http://people.teamix.net/~ms/debian/lenny-backports/btr=
fs-tools/</a><br>
<br>
You can find discussion on sponsoring it here:<br>
<br>
<a href=3D"http://lists.backports.org/lurker-bpo/thread/20100217.143508.417=
36c9f.en.html" target=3D"_blank">http://lists.backports.org/lurker-bpo/thre=
ad/20100217.143508.41736c9f.en.html</a><br>
<br>
I think it won&#39;t work with the latest backports 2.6.30 kernel due to bt=
rfs<br>
format changes, I test it with a self compiled 2.6.32.3. A 2.6.32 for<br>
backports org should be due soon and then my btrfs-tools backport might<br>
appear in the bpo archive as well.<br>
<br>
It basically works, but I am wondering it the RAID options work correctly. =
I<br>
used:<br>
<br>
mkfs.btrfs -d raid1 -m<br>
raid1 /dev/mango1/homelokal1 /dev/mango2/homelokal2<br>
<br>
on two 200 GiB logical volumes and get<br>
<br>
mango:~# df -hT /mnt/zeit<br>
Dateisystem =C2=A0 Typ =C2=A0 =C2=A0Gr=C3=B6=C3=9Fe Benut =C2=A0Verf Ben% E=
ingeh=C3=A4ngt auf<br>
/dev/mapper/mango1-homelokal1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs =C2=A0 =C2=A0400G =C2=A010=
1M =C2=A0400G =C2=A0 1% /mnt/zeit<br>
<br>
Shouldn&#39;t that be 200GiB for a BTRFS Raid 1 setup?<br>
<br></blockquote><div><br></div><div><br></div><div>this has been discussed=
 several times on the list.</div><div><br></div><div>Since btrfs file level=
 redundancy policy, the proper way for it to behave is to show full physica=
l capacity of the devices.</div>
<div><br></div><div>Usage will be correctly accounted, so if you write a 10=
0MB file in that raid1 FS tree</div><div>the used space will indicate 200MB=
 of additional used space.</div><div><br></div><div>Regards,</div><div>
<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
Ciao,<br>
<font color=3D"#888888">--<br>
Martin Steigerwald - team(ix) GmbH - <a href=3D"http://www.teamix.de" targe=
t=3D"_blank">http://www.teamix.de</a><br>
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90<br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Miguel Sousa Fil=
ipe<br>

--00032555bd7e6122b4047fcf1662--
