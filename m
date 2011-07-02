From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: TRIM support
Date: Sat, 02 Jul 2011 15:45:17 -0400
Message-ID: <1309635918.3774.7.camel@nayuki>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
> Hello,
> 
> I just installed an archlinux with btrfs root partition and would like
> to set the correct mount properties
> Following this:
> https://wiki.archlinux.org/index.php/Solid_State_Drives
> it says there that I should use the discard mount parameter to enable TRIM.
> 
> I would like to ask by using ssd mount parameter would TRIM be enabled?
> The SSD is Intel 320 Series 120Gb

No, the "ssd" mount parameter has nothing to do with TRIM.

The "ssd" mount parameter adjusts a couple of tuning parameters where
the default setting is designed to improve performance on spinning HDD,
and instead tunes for the random-access ability of an SSD.

The ssd option is automatically enabled if the kernel detects that your
drive is an SSD (you can check with 'cat /proc/mounts').

The discard option is not currently automatically enabled; I think there
may have been some performance issues in certain cases with drives that
have slow trim implementations. But feel free to give it a try.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

