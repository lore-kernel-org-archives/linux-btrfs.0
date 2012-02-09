From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: Freeing space over reboot question
Date: Thu, 09 Feb 2012 19:57:47 +0100
Message-ID: <20120209185747.92590@gmx.net>
References: <20120209174232.318280@gmx.net>
 <CAAE6i0j02XLf3OGCj_6osrGZpe-Dd9PLmaAg5dB-EzzFJUpQnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0j02XLf3OGCj_6osrGZpe-Dd9PLmaAg5dB-EzzFJUpQnw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Feb 2012 12:11:19 -0600 Chester wrote:

> A similar thing has happened to me recently. The snapshot deletion
> happens asynchronously and should continue after a reboot (in my
> case). If you boot up your system and leave it idle, take a look at
> iotop. You might see a [btrfs-cleaner] doing some work.

No that didn't help. The backup did not start immediately after the reboot and 5 days later - still no change.

    Norbert
