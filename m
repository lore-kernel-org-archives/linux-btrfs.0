From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198
 btrfs_orphan_commit_root+0xa8/0xc0
Date: Thu, 1 Dec 2011 10:14:22 -0500
Message-ID: <20111201151422.GA2250@localhost.localdomain>
References: <4EBA54F2.3030801@unilogicnetworks.net>
 <20111109153552.GB1810@localhost.localdomain>
 <4EBBBFFA.5090000@unilogicnetworks.net>
 <20111114160342.GB1947@localhost.localdomain>
 <4EC2B9E7.7020609@unilogicnetworks.net>
 <20111115192926.GB1944@localhost.localdomain>
 <4EC2C940.40605@unilogicnetworks.net>
 <20111118195226.GB1811@localhost.localdomain>
 <4ED0F44D.3070001@unilogicnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED0F44D.3070001@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 26, 2011 at 03:14:37PM +0100, Stefan Kleijkers wrote:
> Hello Josef,
> 
> I've new results, is this the trace you are looking for?
> 
> Trace of OSD0: http://pastebin.com/gddLBXE4
> Dmesg of OSD0: http://pastebin.com/Uebzgkjv
> 
> OSD1 crashed a while later with the same messages.
> 

Well those look perfect, but that shouldn't be happening, essentially what that
tells me is we've somehow thought that we already have space reserved for that
inode, but we don't, and the only way we test/set that value is under a
spin_lock, so it simply cannot be happening that way.  So can you jack up your
buffer size for ftrace and re-run and get me the same info again to make sure
nothing to lost?  You can do that by doing something like this

echo 4096 > /sys/kernel/debug/traceing/buffer_size_kb

and then running the test and gather the same info as before.  Thanks,

Josef
