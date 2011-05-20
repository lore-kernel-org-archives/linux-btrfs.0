From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Thu, 19 May 2011 20:23:29 -0400
Message-ID: <1305850961-sup-454@shiny>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com> <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, josef <josef@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Liu Bo's message of 2011-05-19 04:11:24 -0400:
> Introduce a new concept "sub transaction",
> the relation between transaction and sub transaction is
> 
> transaction A       ---> transid = x
>    sub trans a(1)   ---> sub_transid = x+1
>    sub trans a(2)   ---> sub_transid = x+2
>      ... ...
>    sub trans a(n-1) ---> sub_transid = x+n-1
>    sub trans a(n)   ---> sub_transid = x+n
> transaction B       ---> transid = x+n+1
>      ... ...
> 
> And the most important is
> a) a trans handler's transid now gets value from sub transid instead of transid.
> b) when a transaction commits, transid may not added by 1, but depend on the
>    biggest sub_transaction of the last neighbour transaction,
>    i.e.
>         B->transid = a(n)->transid + 1,
>         (B->transid - A->transid) >= 1
> c) we start a new sub transaction after a fsync.
> 
> We also ship some 'trans->transid' to 'trans->transaction->transid' to
> ensure btrfs works well and to get rid of WARNings.
> 
> These are used for the new log code.

This is exactly what I had in mind.  I need to read it harder and make
sure it interacts well with the directory logging code, but I love it.

Thanks!

-chris
