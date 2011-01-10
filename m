From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Mon, 10 Jan 2011 10:28:14 -0500
Message-ID: <4D2B258E.7010706@gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net> <1294276285-sup-9136@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Josef Bacik <josef@redhat.com>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294276285-sup-9136@think>
List-ID: <linux-btrfs.vger.kernel.org>


I think that dedup has a variety of use cases that are all very dependent on 
your workload. The approach you have here seems to be a quite reasonable one.

I did not see it in the code, but it is great to be able to collect statistics 
on how effective your hash is and any counters for the extra IO imposed.

Also very useful to have a paranoid mode where when you see a hash collision 
(dedup candidate), you fall back to a byte-by-byte compare to verify that the 
the collision is correct.  Keeping stats on how often this is a false collision 
would be quite interesting as well :)

Ric

