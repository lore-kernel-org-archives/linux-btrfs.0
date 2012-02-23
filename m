From: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
Subject: Re: Is there any data recovery tool?
Date: Thu, 23 Feb 2012 18:16:04 +0800
Message-ID: <CAMtaSwTr5bZg3WSt_ZArkT=amfR0XqnuWy4ZAQbUA00Rhq6PeQ@mail.gmail.com>
References: <CAMtaSwTAeKrvQ2ev7-genxt49ivOAGLYDbKDpO6q1vYExMzj3g@mail.gmail.com>
 <pan.2012.02.22.12.58.49@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.22.12.58.49@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

OK.

On Wed, Feb 22, 2012 at 8:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> qasdfgtyuiop posted on Tue, 21 Feb 2012 20:11:06 +0800 as excerpted:
>
>> I'm using GNU/linux with btrfs root. My filesystem is created with
>> command "mkfs.btrfs /dev/sda" . =A0Today I'm trying to install Micro=
soft
>> Windows 7 on /dev/sdb , a 16GB esata ssd. =A0After the installation,=
 I
>> found that Windows create a "hidden" NTFS partition called "System
>> Reserved" on the first 100MB of my /dev/sda and that my btrfs filesy=
stem
>> was lost! =A0I have searched google for help but I got no useful
>> information. =A0Is there any data recovery tools?
>
> The btrfs kernel option says:
>
> Btrfs filesystem (EXPERIMENTAL) Unstable disk format
>
> Its description says in part:
>
> Btrfs is highly experimental, and THE DISK FORMAT IS NOT YET FINALIZE=
D.
> You should say N here unless you are interested in testing Btrfs with=
 non-
> critical data. [...] If unsure, say N.
>
> The front page and getting started pages of the wiki (see URL below)
> also heavily emphasize the development aspect and backups, and the so=
urce
> code section has this to say:
>
> Warning, Btrfs evolves very quickly do not test it unless:
>
> =A0 =A0You have good backups and you have tested the restore capabili=
ty
> =A0 =A0You have a backup installation that you can switch to when
> =A0 =A0 =A0 =A0something breaks
> =A0 =A0You are willing to report any issues you find
> =A0 =A0You can apply patches and compile the latest btrfs code agains=
t your
> =A0 =A0 =A0 =A0kernel (quite easy with git and dkms, see below)
> =A0 =A0You acknowledge that btrfs may eat your data
> =A0 =A0Backups! Backups! Backups!
>
>
> Given all that, any data you store on btrfs is by definition not part=
icularly
> important, either because you have it backed up in a more stable form=
at
> elsewhere (which might be the net, or local), or because the data rea=
lly
> /isn't/ particularly important to you in the first place, or you'd ha=
ve
> made and tested backups (naturally, always test recovery from your ba=
ckups,
> as an untested backup is worse than none, since it's likely to give y=
ou
> a false sense of security) before putting it on the after all still
> experimental and under heavy development btrfs in the first place.
>
> Thus, you shouldn't need to worry about a data recovery tool, since
> you can either simply restore from backups (which since you tested
> recovery, you're already familiar with the recovery procedures),
> or the data was simply garbage you were using for testing and didn't
> care about losing anyway.
>
>
> Never-the-less, yes, there's a recovery tool, naturally experimental
> just like the filesystem itself at this point, but there is one. =A0T=
esting
> and suggestions for improvements, especially with patches, will be
> welcomed.
>
> It seems you need to read up on the wiki, which covers this among oth=
er
> things. =A0There's an older version on btrfs.wiki.kernel.org, but tha=
t's
> not updated ATM due to restrictions in place since the kernel.org
> breakin some months ago. =A0The "temporary" (but six months and count=
ing,
> I believe) replacement is at btrfs.ipv5.de:
>
> http://btrfs.ipv5.de/index.php?title=3DMain_Page
>
> The restore and find-root commands from btrfs-progs are specifically
> covered on this page:
>
> http://btrfs.ipv5.de/index.php?title=3DRestore
>
> If you wish to try a newer copy of btrfs-progs (after all, it's all
> still in development, and bugs are fixed all the time), you'll also w=
ant
> to read:
>
> http://btrfs.ipv5.de/index.php?title=3DGetting_started#Compiling_Btrf=
s_from_sources
>
>
> --
> Duncan - List replies preferred. =A0 No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master." =A0Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
