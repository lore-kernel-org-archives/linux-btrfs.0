From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Scary OOPS when playing with --bind, --move, and friends
Date: Mon, 20 Dec 2010 22:44:24 -0600
Message-ID: <AANLkTinWqRXMpH4_OBMRTiJoPF3R=LOcT4f5EFLQm2kH@mail.gmail.com>
References: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
	<AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
	<AANLkTi=pXkg1YV9z9GP7Q_vbNj5ZVOcfTfqYJW=QbSvC@mail.gmail.com>
	<AANLkTimpq2qEtRk54ni3uHtCtK+GL_t3wq8_rBEcf4GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimpq2qEtRk54ni3uHtCtK+GL_t3wq8_rBEcf4GQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 20, 2010 at 10:25 PM, C Anthony Risinger <anthony@extof.me>=
 wrote:
> On Mon, Dec 20, 2010 at 10:19 PM, Fajar A. Nugraha <list@fajar.net> w=
rote:
>>
>> Still curious about your test scenario though. Can you double check
>> it? A write on the snapshot should not appear on the parent
>> filesystem.
>
> sorry maybe i wasn't very clear; my current root is a subvol... the
> directory i was --bind mounting corresponded to /home/anthony:
>
> /
>
> and
>
> root/<subvol of my current root>
>
> are the same; so it should show up in my /home/anthony directory. =A0=
if
> mount the subvol by id, then --bind mount, it works as expected; only
> when crossing the magic barrier doesn't things seem to freak out.

s/doesn't/do/g

to be exact, it looks like this:

-----------------------------------------
(subvolid)
        <source>
        <mount>
        [options]

(262)
        /dev/sda
        /

(__0)
        /dev/sda
        /home/anthony/sand/root
        [subvolid=3D0]

(???)
        /home/anthony/sand/root/vols/262/home/anthony
        /home/anthony/sand/bind
        [--bind]
-----------------------------------------

all my subvolumes are kept in a "vols" directory in the btrfs root, so
my / and the --bind mount were suppose to be referencing the same
location.  additionally, TEST showed up in both locations... it was
the editing part that blew up.  NOTE however, that the subvol (id 262)
itself was _never_ actually mounted, it was accessed thru the btrfs
root mounted at `root`.  i think this is the crux of the problem;
--bind doesn't seem to know that the directory it was binding isn't
100% "within" the mount point it resides under.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
