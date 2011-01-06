From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 13:44:54 -0800
Message-ID: <201101061344.55407.CACook@quantum-sci.com>
References: <201101060935.14059.CACook@quantum-sci.com> <AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com> <AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 06 January 2011 12:07:17 C Anthony Risinger wrote:
> as for the DB stuff, you definitely need to snapshot _before_ rsync.  roughly:
> 
> ) read lock and flush tables
> ) snapshot
> ) unlock tables
> ) mount snapshot
> ) rsync from snapshot
> 
> ie. the same as whats needed for LVM:
> 
> http://blog.dbadojo.com/2007/09/mysql-backups-using-lvm-snapshots.html
> 
> to get the DB file on disk consistent prior to archiving.

I'm a little alarmed by this.  Running a mysql server for MythTV database.   Do these operations need to somehow be done before rsync?  Or Else?

I don't understand what you're saying.


