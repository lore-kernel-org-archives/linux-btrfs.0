From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 9 Mar 2012 16:44:26 +0100
Message-ID: <CADDYkjQsXq-bmouJ7fhCOAA2vEqSNSqRdNEmhmMpjN8wMC4v3Q@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
	<CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
	<20120309114010.GH4334@twin.jikos.cz>
	<CADDYkjQiMpPHLq4NTe5yo1iZfCgtwTgm+3ZDRUdMACpumsdFqw@mail.gmail.com>
	<CADDYkjRK3h_e3GPDQMpVwSwn6aQ5MwA1FoF1wFV05=LytK3chg@mail.gmail.com>
	<20120309145406.GL4334@twin.jikos.cz>
	<CADDYkjTTOoLSsp5_c3SsxfAmUH=qOeE_rtLT25dOY6f-3f7Eww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADDYkjTTOoLSsp5_c3SsxfAmUH=qOeE_rtLT25dOY6f-3f7Eww@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/9 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/3/9 David Sterba <dave@jikos.cz>:
>> On Fri, Mar 09, 2012 at 03:33:24PM +0100, Jacek Luczak wrote:
>>> > Those two issues go inline. After a longer while of WARN_ON the BUG_ON
>>> > hit again.
>>>
>>> One more observation. Host is running builds from CI system. After
>>> BUG_ON pop up all builds take 50% more time to complete.
>>
>> After a BUG_ON the system is in an inconsistent state and will
>> misbehave.
>>
>>> Also I see that current load average stall at value of 7 even if host
>>> is completely idle.
>>
>> That's probably because some process is stuck in a D-state after the
>> crash.
>>
>
> Now when I've tried to bring CI back I had to clean the broken builds
> from BUG_ON run. The svn up fails:
>
> open("/btrfs/project1/.svn/lock", O_WRONLY|O_CREAT|O_EXCL, 0666) = -1
> ENOSPC (No space left on device)
>

btrfsck shows a lot of:
root 5 inode 52651143 errors 400
root 5 inode 52651144 errors 400
root 5 inode 52651163 errors 400
root 5 inode 52651164 errors 400
root 5 inode 52651165 errors 400
found 142180204544 bytes used err is 1
total csum bytes: 0
total tree bytes: 7636135936
total fs tree bytes: 7371886592
btree space waste bytes: 2119907598
file data blocks allocated: 134544068608
 referenced 134544068608

-Jacek
