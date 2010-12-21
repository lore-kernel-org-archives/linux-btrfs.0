From: cwillu <cwillu@cwillu.com>
Subject: Re: Scary OOPS when playing with --bind, --move, and friends
Date: Mon, 20 Dec 2010 22:18:08 -0600
Message-ID: <AANLkTimo6fFFzfEa38Oz0uhvysLJqJ1+ngmxTqgrs2h6@mail.gmail.com>
References: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
	<AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: C Anthony Risinger <anthony@extof.me>, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 20, 2010 at 10:16 PM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Tue, Dec 21, 2010 at 10:51 AM, C Anthony Risinger <anthony@extof.me> wrote:
>> in short, everything works fine until you --bind across a subvol via
>> the "special" folders created when one takes a snapshot,
>
>> # mount --bind root/<subvol of my current root>/home/anthony bind
>> # touch bind/TEST
>>
>> <you can now see TEST at ~/TEST and bind/TEST>
>
> bind/ is a mounted snapshot, right? if yes, then when you "touch
> bind/TEST", it should also appear in root/<subvol of my current
> root>/home/anthony/TEST, and NOT in root/home/anthony/TEST or
> /home/anthony/TEST
>
>> i'm on 2.6.36.2
>
> Try 2.6.35 or later. I tested something similar under ubuntu maverick
> (2.6.35-24-generic) and it works just fine.

Last I checked, 2.6.36 came after 2.6.35.  :)
