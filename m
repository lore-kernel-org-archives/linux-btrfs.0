From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Recovering "parent transid verify failed"
Date: Wed, 23 Mar 2011 20:07:03 -0400
Message-ID: <1300925154-sup-1589@think>
References: <8C6E0242B0336C4CB6065C37C0A2A959EB2E550547@londondc02.an0key.net>
Content-Type: text/plain; charset=UTF-8
Cc: btrfs hackers <linux-btrfs@vger.kernel.org>
To: Luke Sheldrick <luke@sheldrick.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <8C6E0242B0336C4CB6065C37C0A2A959EB2E550547@londondc02.an0key.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Luke Sheldrick's message of 2011-03-23 14:12:45 -0400:
> Hi,
> 
> I'm having the same issues as previously mentioned.
> 
> Apparently the new fsck tool will be able to recover this?
> 
> Few questions, is there a GIT version I can compile and use already for this?
> 
> If not, is there any indication of when this will be released?

Yes, I'm still hammering out a reliable way to resolve most of these.
But, please post the messages you're hitting, it is actually a very
generic problem and has many different causes.

What happened to your FS that made them come up?

Which kernel were you running and what was the FS built on top of?

What happens when you grab the latest btrfsck from git and do:

btrfsck -s 1 /dev/xxx

-chris
