From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 1 Mar 2012 21:13:11 +0700
Message-ID: <CAG1y0sfT8_wtPLkyFP-uXLjof=Rk0AX_wyJR7q-J=PA-o82yWQ@mail.gmail.com>
References: <4E4B2452.9070407@oracle.com>
	<20110817140433.GA32261@hendrix.borisch.local>
	<4E4BD53A.7080708@pacific.net>
	<20110817173837.GA29509@suse.com>
	<CAG1y0sdhm03Pqi+j2Z00MS+p5CMQav=r0c7LahNpjJRv+rEQmw@mail.gmail.com>
	<20120301134817.GA15719@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120301134817.GA15719@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 1, 2012 at 8:48 PM, Arvin Schnell <aschnell@suse.de> wrote:
> On Thu, Feb 23, 2012 at 04:54:06PM +0700, Fajar A. Nugraha wrote:
>> On Thu, Aug 18, 2011 at 12:38 AM, Matthias G. Eckermann <mge@suse.co=
m> wrote:
>
>> > are available in the openSUSE buildservice at:
>> >
>> > =A0 =A0 =A0 =A0http://download.opensuse.org/repositories/home:/mge=
1512:/snapper/
>> >
>>
>> Hi Matthias,
>>
>> I'm testing your packages on top of RHEL6 + kernel 3.2.7. A small
>> suggestion, you should include /etc/sysconfig/snapper in the package
>> (at least for RHEL6, haven't tested the other ones). Even if it just
>> contains
>>
>> SNAPPER_CONFIGS=3D""
>
> Hi Fajar,
>
> thanks for reporting that issue, I have fixed it now.

Great! Thanks.

>
> We have now created a project in the openSUSE buildservice were
> we provide snapper packages for various distributions, e.g. RHEL6
> and Fedora 16. Please find the downloads at:
>
> =A0http://download.opensuse.org/repositories/filesystems:/snapper/
>
> I'll also add a link from the snapper home page:
>
> =A0http://en.opensuse.org/Portal:Snapper.
>
> I have tested snapper on Fedora 16 and found no problems.

When I installed it back then, the first thing that comes to mind was
"there's no documentation on how to get started".

http://en.opensuse.org/openSUSE:Snapper_Tutorial is good, but that' is
assuming root is btrfs, and snapper is already configured to snapshot
root. For other distros, you need to first create the config manually,
e.g. as shown for home in http://en.opensuse.org/openSUSE:Snapper_FAQ

Could you update the tutorial, or perhaps create a new "quickstart"
page? I'm kinda reluctant to do it myself since I don't use opensuse,
and some of my edits might not reflect the "correct" way to do it in
opensuse. If that's not possible, I'll put up the documentation
somewhere else (perhaps the semi-official http://btrfs.ipv5.de/ , or
my own wiki).

Two other things that I have't find is:
- how to add pre and post hooks, so (for example) snapper could create
the same pre-post snapshot whenever user runs "yum", similar to when a
user runs "yast" in opensuse,
- whether a rollback REALLY rolls back everyting (including binary and
new/missing files), or is it git-like behavior, or if it only process
text files.

=2E.. but those two aren't as important as the getting-started document=
ation.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
