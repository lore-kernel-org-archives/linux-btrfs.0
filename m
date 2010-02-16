From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/2] btrfs: a new tool to manage a btrfs filesystem
Date: Tue, 16 Feb 2010 09:31:22 -0800
Message-ID: <93cdabd21002160931v27f97ef7o2d77d26205b6d1cd@mail.gmail.com>
References: <57271D7A-6077-4DAF-9B21-B3CFD99B9C3B@kupper.org>
	 <201002141639.32634.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002141639.32634.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 14, 2010 at 7:39 AM, Goffredo Baroncelli <kreijack@gmail.co=
m> wrote:
> Hi all,
>
> On Sunday 14 February 2010, Thomas Kupper wrote:
>> Hi Goffredo,
>>
>> Great work! It is indeed much easier to work with one tool instead w=
ith the
> many of them!
>>
>> > Usage:
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs snapshot|-s <source> [<dest>/]<n=
ame>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Create a w=
riteble snapshot of the subvolume
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <source> w=
ith the name <name> in the <dest>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 directory.
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs delete|-D <subvolume>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Delete the=
 subvolume <subvolume>.
>>
>>
>> I backup up Mike on the opinion that the short options aren't what I=
 would
> expect. Personally I'd prefer a command line syntax like git, "<comma=
nd>
> <action> [sub-action> <options>|<arguments] ...".
>
> Seriously, you (as also Michel and Mike) raised some concern about th=
e command
> line syntax. The main issues are:
> 1) possible mistaken between the '-d' (delete) command and '-D' (defr=
ag)
> command. It was suggested to remove the short form command.
> 2) some commands are not very auto-explainant
>
> Regarding the point #1, I am against about removing the short command=
 ('-
> s'...). If someone fears to mistake, he has the option to use the log=
 form
> command. But I don't see any reason to force all others peoples to us=
e the
> long form command.

The problem here is maintainability of scripts when people use the
short names.  I will refer to the "ip" command used in linux
networking.

It has these subcommands:
where  OBJECT :=3D { link | addr | addrlabel | route | rule | neigh |
ntable | tunnel |
                   maddr | mroute | monitor | xfrm }

Which are listed here:

ip link
ip addr
ip addrlabel
ip route
ip rule
ip neigh
ip ntable
ip tunnel
ip maddr
ip mroute
ip monitor
ip xfrm

You can shorten them as long as they are not ambiguous:

ip ro =3D ip route
ip ru =3D ip rule
ip a =3D ip addr
ip l =3D ip link

Those are the ones I used most personally.

There are no equivalent short options, and you don't have different
sets of people using different commands in scripts and howtos for
instance.  It builds a common base of knowledge and is easy to type
from memory.

Commands that document themselves are good IMO.

ip route replace default via 1.2.3.4

Replace or set the current default to ip address 1.2.3.4 (the tool
makes sure 1.2.3.4 is reachable by an already existing route and looks
up the layer 2 address for that ip.

It's not "ip -r default -d 1.2.3.4"

Now someone reading a howto or script with that hypothetical command
will have to find out if -r is route or -R is rule.  This is how the
btrfs commands currently look to me.

> If there is an agreement I am open to rename the command "-D/delete" =
in order
> to reduce the conflict. For examples the -D/delete command may be ren=
amed as -
> R/remove. The conflict with the -r/resize command is not a problem be=
cause the
> former requires 1 arguments, the latter two. Another renaming option =
may be -
> E/erase.
>

This just illustrates my point.  Btrfs has a rich feature set and the
short option formats are only going to create more confusion because
some of them will only be usable with a subset of operations and there
will be so many things you can do with btrfs that explicit long
options are needed to make it clear even to yourself what it does 6
months later.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
