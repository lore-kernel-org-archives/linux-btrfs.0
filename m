Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.inserm.fr ([195.98.252.37]:37651 "EHLO smtp.inserm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2I0LwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 07:52:18 -0400
Message-ID: <20120927135213.tw21cc7zbbk8wscg@imp.inserm.fr>
Date: Thu, 27 Sep 2012 13:52:13 +0200
From: =?utf-8?b?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, sebastien.maury@inserm.fr
Subject: Re: BTRF - Storage Usage
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
	<20120927110957.GC6136@carfax.org.uk>
	<20120927132558.38yjm32rcw4o40ws@imp.inserm.fr>
	<20120927114332.GD6136@carfax.org.uk>
In-Reply-To: <20120927114332.GD6136@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks a lot for your time and answers.

Things look pretty clear now for me.

I'm monitoring my systems using nagios, and i was annoyed about the  
disk usage monitoring.
Thanks to your answers, i should be able to developp a rather accurate script.
Or so i hope :)

Regards,
Sebastien.

Hugo Mills <hugo@carfax.org.uk> a écrit :

> On Thu, Sep 27, 2012 at 01:25:58PM +0200, Sébastien Maury wrote:
>> Hi,
>>
>> Thanks for the quick reply, this clarify me lots of things.
>> I've had read the articles you mentioned, but i must admit that your
>> explanations based on my examples makes things even more clearer.
>>
>> Also, if i understand things properly, snaphots size aren't included
>> in the "btrfs filesystem show" command output ?
>> So, the use, for example, of a "du -sh /.snapshots" is correct to
>> determine the disk usage of my snapshots ?
>
>    "Disk usage of a snapshot" has two different answers:
>
> 1) The total size of the files listed in the snapshot, which you can
>    get from du.
>
> 2) The amount of space that would be freed up by deleting the
>    snapshot, which isn't currently available, but probably will be
>    soon. (The additional bookkeeping code was part of the qgroups
>    patches, which are in 3.6).
>
>> I will see with the people of my company in charge of maintaining
>> distributions to provide us a more recent kernel.
>>
>> PS : I use SLES 11 SP2 distribution.
>
>    OK, that one's actually one of the few that does keep proper
> backports:   
> https://btrfs.wiki.kernel.org/index.php/Getting_started#Distro_support
>
>    That said, I don't know how good they are at keeping up -- probably
> pretty good, but other people here may be able to answer that better.
>
>    Hugo.
>
>> Hugo Mills <hugo@carfax.org.uk> a écrit :
>>
>> > On Thu, Sep 27, 2012 at 12:44:27PM +0200, Sébastien Maury wrote:
>> >> I've installed a new server using btrfs for my root partition ("/").
>> >>
>> >> It uses snapper for snapshots management and all seems to work   
>> pretty fine.
>> >>
>> >> My problem is to be able to know the remaining REAL free space in my
>> >> partition.
>> >
>> >    This is in the FAQ:
>> >   
>> https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_there_so_many_ways_to_check_the_amount_of_free_space.3F
>> >
>> >    Short answer: you can't know in general.
>> >
>> >    Longer answer -- see below.
>> >
>> >> Using different commands, i have different results, and i don't know
>> >> how to interpret them correctly :
>> >
>> >> poivron:~ # btrfs filesystem show /dev/sda3
>> >> Label: none  uuid: 9e68b667-f9f9-490f-9da1-ae4e91558212
>> >>          Total devices 1 FS bytes used 2.58GB
>> >>          devid    1 size 131.64GB used 10.04GB path /dev/sda3
>> >
>> >    You have 131.64 GiB of raw storage in your filesystem. Of that,
>> > 10.04 GiB is currently allocated for use by the FS (and it will take
>> > more as it needs it).
>> >
>> >> poivron:~ # btrfs filesystem df /
>> >> Data: total=4.01GB, used=2.16GB
>> >
>> >    4.01 GiB of the 10.04 GiB allocation is assigned for use by data,
>> > and 2.16 GiB of that allocation actually contains data.
>> >
>> >> System, DUP: total=8.00MB, used=4.00KB
>> >
>> >    16 MiB (=2*8.00 MiB) of the 10.04 GiB allocation is assigned for
>> > use as two copies of the system data. There is 4 KiB of system data
>> > actually used.
>> >
>> >> System: total=4.00MB, used=0.00
>> >> Metadata, DUP: total=3.00GB, used=429.16MB
>> >
>> >    6 GiB (=2*3.00 GiB) of your 10.04 GiB allocation is assigned for
>> > use as metadata, with two copies (DUP) being kept. 429.16 MiB of the
>> > 3.00 GiB is currently in use.
>> >
>> >> Metadata: total=8.00MB, used=0.00
>> >
>> >> poivron:~ #  df -hP /
>> >> Filesystem      Size  Used Avail Use% Mounted on
>> >> /dev/sda3       132G  3.0G  124G   3% /
>> >
>> >    Plain old df can't handle the truth, so this is at best only a hint
>> > at what's actually happening. When "Avail" reaches zero, your FS is
>> > probably full. Other than that, you can't necessarily say very much.
>> >
>> >> ===========
>> >>
>> >> Please help me understand and interpret those information to know the
>> >> most accurately as possible what is my real remaining space, and what
>> >> space is used by what.
>> >>
>> >> Although, i don't really understand the output of the command "btrfs
>> >> filesystem df /" : what are exactly "Data", "System DUP", "System
>> >> total", "Metadata DUP" and "Metadata total" ?
>> >
>> >    This should all be covered in the glossary on the website:
>> > https://btrfs.wiki.kernel.org/index.php/Glossary
>> >
>> >    Data is the contents of your files. Metadata is all the other stuff
>> > that the FS needs in order to store your files -- directory
>> > structures, permissions, locations of the file data, that kind of
>> > thing. System is a particular bit of the metadata (the chunk tree)
>> > which governs an internal physical/virtual mapping, and which needs to
>> > be read before anything else can make any kind of sense.
>> >
>> >    DUP is a bit like RAID-1: anything stored in a DUP chunk is
>> > actually written to two different places on the disk, and can help
>> > recovery in the case of physical disk corruption (e.g. bad blocks,
>> > head crash).
>> >
>> >> ==========
>> >>
>> >> Here are some complementary informations :
>> >> poivron:~ # uname -a
>> >> Linux poivron 3.0.26-0.7-default #1 SMP Tue Apr 17 10:27:57 UTC 2012
>> >> (3829766) x86_64 x86_64 x86_64 GNU/Linux
>> >
>> >    You [probably(*)] need to upgrade your kernel as soon as possible.
>> > btrfs code moves very fast, and 3.0 has significant bugs in it. You
>> > should be running the latest released kernel -- right now, that's 3.5,
>> > or 3.6-rc7. Next week, it will probably change to 3.6 when Linus makes
>> > the next release. Most distributions have a repository somewhere which
>> > will give you access to new kernels without too much trouble.
>> >
>> >    Hugo.
>> >
>> > (*) Some of the enterprise distributions do have backported btrfs
>> > fixes in their apparently older kernels.
>> >
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>         --- A clear conscience.  Where did you get this taste ---
>                          for luxuries,  Bernard?
>



Cordialement,

Sébastien MAURY
Responsable d'exploitation du site de Montpellier
Équipe DBA
___________________________________
INSERM - DSI - Pôle Infrastructures

Délégation régionale Languedoc Roussillon
60, rue de Navacelles
34394 Montpellier Cedex 5

Mob : 06 31 51 42 18
Fixe : 04 67 63 61 43
Fax : 04 67 63 70 25
Mél : sebastien.maury@inserm.fr
___________________________________


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


