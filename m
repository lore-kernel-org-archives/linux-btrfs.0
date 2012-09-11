Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41187 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab2IKXdG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 19:33:06 -0400
Received: by pbbrr13 with SMTP id rr13so1463801pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 16:33:05 -0700 (PDT)
Message-ID: <504FCA2E.90906@gmail.com>
Date: Wed, 12 Sep 2012 07:33:02 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: enquiry about defrag
References: <504BDCE0.8020407@gmail.com> <504F1CBA.6030201@gmail.com> <20120911114559.GV17430@twin.jikos.cz>
In-Reply-To: <20120911114559.GV17430@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2012 07:45 PM, David Sterba wrote:
> On Tue, Sep 11, 2012 at 07:12:58PM +0800, ching wrote:
>>> 1. According to btrfs wiki, defragment a COW file will produce two unrelated files.
>>>
>>>     Does it apply to the "autodefrag" mount option?
>> can anybody helps on question 1?
> The data blocks associated with the files (that were originally created
> by snapshotting and thus shared the same blocks) will become unshared,
> so yes it would appear like two unlreated files.
>
> Autodefrag option affects only newly written data. With current
> implementation it could unshare some extents if the defragged range
> picked by autodefrag logic overlaps with an existing one.
>
> >From my experience, running 'btrfs fi defrag' with autodefrag on
> produced better result. Beware that there are some unfixed deadlocks
> that may happen with autodefrag enabled.
>
> david
>

thanks for your help very much :)
