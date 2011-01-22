From: cwillu <cwillu@cwillu.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Sat, 22 Jan 2011 17:53:58 -0600
Message-ID: <AANLkTin5TvfhPK0Osp-rcJaNUO90Ts3OcVot8ve5Qn-u@mail.gmail.com>
References: <1295298216-sup-6206@think>
	<20110118101436.GA2652@scooter>
	<AANLkTimDGtzw9GSC7FigFsKO+w9cO30LUZ2=XK0aK9Hj@mail.gmail.com>
	<4D36ABC0.1060109@shiftmail.org>
	<AANLkTi=6JNDGj1ViiyvPRGDj1kNGg+SCr=1a=y0ACad+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=6JNDGj1ViiyvPRGDj1kNGg+SCr=1a=y0ACad+@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 22, 2011 at 5:41 PM, Clemens Eisserer <linuxhippy@gmail.com> wrote:
>> E.g. suppose you have a LZO compressed file, then a program rewrites some
>> data which is in the middle of the file, and suppose the newly written data
>> is less compressible.
>
> Any idea how this is handled? I would be interested in the answer as well.
>
> Thank you in advance, Clemens

The same way any write is handled:  the data is written elsewhere.
Compression isn't special in this regard.
