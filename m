From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: How Snapshots Inter-relate?
Date: 22 Apr 2011 17:39:00 +0200
Message-ID: <BkLbhDoy1uB@helmut.hullen.de>
References: <1303411647.25281.2.camel@ayu>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303411647.25281.2.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Calvin,

Du meintest am 21.04.11:

>> I have set up a backup server in the garage which does rsync backups
>> of all my servers weekly, and snapshots those backups.

[...]

> You have nothing to worry about. You can delete any snapshot on btrfs
> without losing data from any other snapshot. Each snapshot is
> completely independent.

> This works because data which is shared between multiple snapshots is
> reference counted, and won't be deleted until you remove the last
> snapshot that references that data.

That sounds like "hard links"; I use that with my favourite backup  
program "rsnapshot". I like it.

But: if the (only) target of the (many) hard links fails, then it fails  
in all backups. It's a very good idea to make monthly or yearly backups  
of one such hard linked backup to another disk.

Viele Gruesse!
Helmut
