From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Scary OOPS when playing with --bind, --move, and friends
Date: Mon, 20 Dec 2010 22:25:02 -0600
Message-ID: <AANLkTimpq2qEtRk54ni3uHtCtK+GL_t3wq8_rBEcf4GQ@mail.gmail.com>
References: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
	<AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
	<AANLkTi=pXkg1YV9z9GP7Q_vbNj5ZVOcfTfqYJW=QbSvC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=pXkg1YV9z9GP7Q_vbNj5ZVOcfTfqYJW=QbSvC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 20, 2010 at 10:19 PM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Tue, Dec 21, 2010 at 11:16 AM, Fajar A. Nugraha <list@fajar.net> wrote:
>> On Tue, Dec 21, 2010 at 10:51 AM, C Anthony Risinger <anthony@extof.me> wrote:
>>> i'm on 2.6.36.2
>>
>> Try 2.6.35 or later. I tested something similar under ubuntu maverick
>> (2.6.35-24-generic) and it works just fine.
>
> Sorry, hit "send" to soon. I though you wrote "2.6.32" :P
>
> Still curious about your test scenario though. Can you double check
> it? A write on the snapshot should not appear on the parent
> filesystem.

sorry maybe i wasn't very clear; my current root is a subvol... the
directory i was --bind mounting corresponded to /home/anthony:

/

and

root/<subvol of my current root>

are the same; so it should show up in my /home/anthony directory.  if
mount the subvol by id, then --bind mount, it works as expected; only
when crossing the magic barrier doesn't things seem to freak out.

i actually reproduced it twice, but this time i didn't write to the files :-)

C Anthony
