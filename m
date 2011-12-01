From: Stefan Kleijkers <stefan@unilogicnetworks.net>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Thu, 01 Dec 2011 21:03:22 +0100
Message-ID: <4ED7DD8A.8010104@unilogicnetworks.net>
References: <4EBA54F2.3030801@unilogicnetworks.net> <20111109153552.GB1810@localhost.localdomain> <4EBBBFFA.5090000@unilogicnetworks.net> <20111114160342.GB1947@localhost.localdomain> <4EC2B9E7.7020609@unilogicnetworks.net> <20111115192926.GB1944@localhost.localdomain> <4EC2C940.40605@unilogicnetworks.net> <20111118195226.GB1811@localhost.localdomain> <4ED0F44D.3070001@unilogicnetworks.net> <20111201151422.GA2250@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111201151422.GA2250@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

Will do, thanks! As soon as I have results I will let you know.

I did already a rerun (without the bigger buffer size), but 
unfortunately I couldn't get the trace (like Christian). If I tried to 
cat from the trace it hung.

Stefan

On 12/01/2011 04:14 PM, Josef Bacik wrote:
> On Sat, Nov 26, 2011 at 03:14:37PM +0100, Stefan Kleijkers wrote:
>> Hello Josef,
>>
>> I've new results, is this the trace you are looking for?
>>
>> Trace of OSD0: http://pastebin.com/gddLBXE4
>> Dmesg of OSD0: http://pastebin.com/Uebzgkjv
>>
>> OSD1 crashed a while later with the same messages.
>>
> Well those look perfect, but that shouldn't be happening, essentially what that
> tells me is we've somehow thought that we already have space reserved for that
> inode, but we don't, and the only way we test/set that value is under a
> spin_lock, so it simply cannot be happening that way.  So can you jack up your
> buffer size for ftrace and re-run and get me the same info again to make sure
> nothing to lost?  You can do that by doing something like this
>
> echo 4096>  /sys/kernel/debug/traceing/buffer_size_kb
>
> and then running the test and gather the same info as before.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

