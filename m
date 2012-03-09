From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 9 Mar 2012 15:33:24 +0100
Message-ID: <CADDYkjRK3h_e3GPDQMpVwSwn6aQ5MwA1FoF1wFV05=LytK3chg@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
	<CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
	<20120309114010.GH4334@twin.jikos.cz>
	<CADDYkjQiMpPHLq4NTe5yo1iZfCgtwTgm+3ZDRUdMACpumsdFqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADDYkjQiMpPHLq4NTe5yo1iZfCgtwTgm+3ZDRUdMACpumsdFqw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/9 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/3/9 David Sterba <dave@jikos.cz>:
>> On Fri, Mar 09, 2012 at 12:08:12PM +0100, Jacek Luczak wrote:
>>> For this one I've created also a report [1].
>>> >
>>> > so there is probably other problem in reservations and it just blew up during
>>> > the unlink call.
>>>
>>> Could be as this came up after a longer time of throwing above WARN_ON.
>>>
>>> I'm now cloning the Linus tree. Lets see if both will pop up on there.
>>
>> The 3.3-rc6 should help in one case, with
>>
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/15268
>>
>> but I was able to reproduce the WARN_ON even with this patch, didn't get
>> to debugging it again yet.
>
> Those two issues go inline. After a longer while of WARN_ON the BUG_ON
> hit again.

One more observation. Host is running builds from CI system. After
BUG_ON pop up all builds take 50% more time to complete. Also I see
that current load average stall at value of 7 even if host is
completely idle.

-Jacek
