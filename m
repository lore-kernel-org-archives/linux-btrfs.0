From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 00:05:12 +0100
Message-ID: <20081210000512.7be20413@diego-desktop>
References: <20081209145952.GA30494@tux64-03>
	<f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>
	<200812091722.21567.mail@earthworm.de>
	<20081209180951.GA6551@tux64-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com,
	linux-btrfs@vger.kernel.org
To: "Lee Trager" <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081209180951.GA6551@tux64-03>
List-ID: <linux-btrfs.vger.kernel.org>

El Tue, 9 Dec 2008 13:09:51 -0500, "Lee Trager" <lt73@cs.drexel.edu> es=
cribi=C3=B3:

> It does seem that doing it with volumes would limit user control and =
add
> lots of complexity to such a simple task.

IMHO, WRT compression it's the contrary. Compression on a per-file basi=
s has
never been very succesful (just look at how many windows users use it)
because it implies taking a decision for every file on the system. OTOH=
,
volume-level is just a single option to be enabled.

I'm of course not arguing that file-level compression shouldn't be poss=
ible,
im just saying that is way more difficult to administer and that most p=
eople
(including sysadmins) is most likely to use compression in a per-volume=
 basis.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
