From: cwillu <cwillu@cwillu.com>
Subject: Re: Re: Two way mirror in BRTFS
Date: Fri, 30 Dec 2011 09:31:51 -0600
Message-ID: <CAE5mzviVPjHwem85ogbHEn6YhzmpqXGh25UjtbTTvD6gMnhnAw@mail.gmail.com>
References: <135535.24205.61145-582-206632053-1325253564@email.cz>
	<925a66c275d286669ba618e277e99cc3.squirrel@webmail.decarpentier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: jaromir.zdrazil@email.cz, linux-btrfs@vger.kernel.org
To: Niels de Carpentier <niels@decarpentier.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <925a66c275d286669ba618e277e99cc3.squirrel@webmail.decarpentier.com>
List-ID: <linux-btrfs.vger.kernel.org>

> For btrfs bugs are still fixed on a daily basis, and some reports of
> people with corrupted and unrecoverable filesystems.

I don't know that there's been any actual unrecoverable filesystems
recently; unmountable is by far the more common issue, and given that
most sane people aren't putting their only copy of important
information on btrfs filesystems, their preference tends to be towards
wiping and starting over rather than spending a week to recover the
information by hand (the recovery tools that exist are the results of
the few who chose the other option).

I think "... people with corrupted and not easily recoverable" would
be a better summary.
