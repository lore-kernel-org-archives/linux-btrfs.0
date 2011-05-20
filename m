From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: No space left, with 80 GB space free
Date: Fri, 20 May 2011 18:35:42 +0200
Message-ID: <4DD6985E.8040100@wpkg.org>
References: <4DD16817.9020302@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD16817.9020302@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 16.05.2011 20:08, Tomasz Chmielewski wrote:

> The kernel used was 2.6.39-rc5.
> 
> If it matters, I had the filesystem mounted with compress-force flag:

Nobody has a clue what makes btrfs run out of space when used with PostgreSQL, even when there is plenty of free space left?


# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb4             336G  257G   78G  77% /mnt/btrfs


coredb=# DELETE FROM core_trevent where "date" < E'2011-05-07 00:00';
ERROR:  could not write block 1014999 of relation base/16384/16521: No space left on device
CONTEXT:  writing block 1014999 of relation base/16384/16521



-- 
Tomasz Chmielewski
http://wpkg.org
