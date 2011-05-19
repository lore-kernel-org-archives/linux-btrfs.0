From: cwillu <cwillu@cwillu.com>
Subject: Re: ssd option for USB flash drive?
Date: Thu, 19 May 2011 16:19:18 -0600
Message-ID: <BANLkTinjgDZs_Bxe6=e25nhu+JAsibaH8A@mail.gmail.com>
References: <20110517220252.GA12323@yahoo.fr>
	<201105192104.58726.hka@qbs.com.pl>
	<20110519214721.GA4209@yahoo.fr>
	<BANLkTinxt3N2_=STRiiJsOAYWEd2-yx_FA@mail.gmail.com>
	<20110519221233.GB4209@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110519221233.GB4209@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2011 at 4:12 PM, Stephane Chazelas
<stephane_chazelas@yahoo.fr> wrote:
> 2011-05-19 15:54:23 -0600, cwillu:
> [...]
>> Try with the "ssd_spread" mount option.
> [...]
>
> Thanks. I'll try that.
>
>> > I wonder now what credit to give to recommendations like in
>> > http://www.patriotmemory.com/forums/showthread.php?3696-HOWTO-Increase-write-speed-by-aligning-FAT32
>> > http://linux-howto-guide.blogspot.com/2009/10/increase-usb-flash-drive-write-speed.html
>> >
>> > Doing a apt-get upgrade on that stick takes hours when the same
>> > takes a few minutes on an internal drive.
>>
>> Also, there's a package "libeatmydata" which will provide an
>> "eatmydata" command, which you can prefix your apt-get commands with.
>> This will disable the excessive sync calls that dpkg makes, and should
>> dramatically decrease the time for those sorts of things to finish.
>> Flash as found in thumb drives doesn't have much in the way of crash
>> guarantees anyway, so you're not really giving up much safety.
>
> Thanks. That's very useful indeed.
>
> Note that if you use that on aptitude/apg-get that means that
> the daemons started/restarted in the process will be affected,
> but it could be all the better in my case.

Heh, that's a thought I hadn't actually considered :p

That shouldn't affect any services that are managed by message
passing, and so really should be limited to those services from
/etc/init.d/ that don't restart themselves (i.e., where the restart
command is implemented by stop + start rather than telling the already
running process to re-execute), or newly installed services that again
are managed via /etc/init.d/.
