Return-Path: <SRS0=OwOL=RT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018ABC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 22:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5DFA218AC
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 22:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfCPWLT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 18:11:19 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:40912 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfCPWLT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 18:11:19 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 3305F5FDB5;
        Sat, 16 Mar 2019 22:11:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id woUTcG1uoZYB; Sat, 16 Mar 2019 22:11:13 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Sat, 16 Mar 2019 22:11:13 +0000 (UTC)
Message-ID: <303507e634c36af048ac36c7233c3b2af8311b46.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Sat, 16 Mar 2019 23:11:10 +0100
In-Reply-To: <20190315052827.GH23918@hungrycats.org>
References: <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
         <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
         <20190215054031.GC9995@hungrycats.org>
         <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
         <20190307200712.GG23918@hungrycats.org>
         <beebed47702d783e00d3478f217ffc646d47bb92.camel@scientia.net>
         <20190315052827.GH23918@hungrycats.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 2019-03-15 at 01:28 -0400, Zygo Blaxell wrote:
> But maybe there should be something like a btrfs-announce list,
> > i.e. a
> > low volume mailing list, in which (interested) users are informed
> > about
> > more grave issues.
> > …
> I don't know if it would be a low-volume list...every kernel release
> includes fixes for _some_ exotic corner case.

Well this one *may* be exotic for many users, but we have at least the
use case of qemu which seems to be not that exotic at all.

And the ones you outline below seem even more common?


Also the other means for end-users to know whether something is stable
or not like https://btrfs.wiki.kernel.org/index.php/Status don't seem
to really work out.

There is a known silent data corruption bug which seems so far only
fixed in 5.1rc* ... and the page still says stable since 4.14.
Even know with the fix, one should probably need to wait a year or so
until one could mark it stable again if nothing had been found by then.



> > What about the direct IO issues that may be still present and which
> > you've mentioned above... is this used somewhere per default /
> > under
> > normal circumstances?
> 
> Direct IO is an odd case because it's not all that well understood
> what the correct behavior is.  You can't prevent the kernel from
> making
> copies of data and also expect full data integrity and also lock-free
> performance, all at the same time.  Pick any two, and pay for it with
> losses in the third.
> 
> The bug fixes here are more along the lines of "OK so you're using
> direct
> IO which means you've basically admitted you don't care about *your*
> data,
> let's try not to corrupt *other* data on the filesystem at the same
> time."

So... if btrfs allows for direct IO... and if this isn't stable in some
situations,... what can one do about it? I mean there doesn't seem to
be an option to disallow it... and any program can do O_DIRECT (without
even knowing btrfs is below).




Guess I have to go deeper down the rabbit hole now for the other
compressions bugs...


> I found the 2017 compression bug in a lot of digital photographs.

Is there any way (apart from having correct checksums) to find out
whether a file was affected by the 2017-bug?
Like, I don't know,.. looking for large chunks of zeros?


And is there any more detailed information available on the 2017-bug,
in the sense under which occasions it occurred?

Like also only on reads (which would mean again that I'd be mostly
safe, because my checksums should mostly catch this)?

Or just on dedupe or hole punching? Or did it only affect sparse files
(and there only the holes (blocks of zeros) as in your camera JPG
example)?


> It turns out that several popular cameras (including some of the ones
> I
> own) put a big chunk of zeros near the beginnings of JPG files, and
> when
> rsync copies those it will insert a hole instead of copying the
> zeros.

Many other types of files may have such bigger chunks of zeros to...
basically everything that leaves place for meta-data.


> The 2017 bug affected "ordinary" holes so standard tools like cp and
> rsync could trigger it.

AFAIU, both cp and rsync (--sparse) don't create spares files actively
per default,... cp (per default) only creates sparse files when it
detects the source file to be already sparse.
Same seems to be the case for tar, which only stores a file sparse
(inside the archive) when --sparse is used.

So would one be safe from the 2017 bug if one haven't had sparse files
and not activated the sparse in any of these tools?


>   Most photo tools ignore this data completely,
> so when garbage appears there, nobody notices.

So the 2017-bug meant that areas that should be zero were filled with
garbage but everything als was preserved correclty



> I don't think I found an application that cared about the 2017 bug at
> all.

Well for me it would be still helpful to know how to find out whether I
might have been affected or not... I do have some really old backups so
recovery would be possible in many cases.



> The 2018 bug is a different story--when it hits, it's obvious, and
> ordinary application things break

Which one to you mean now? The one recently fixed on
reads+holepunching/dedupe/clone? Cause I thought that one was not not
that obvious as it was silent...


Anything still known about the even older compression related
corruption bugs that Filipe mentioned, in the sense when they occurred
and how to find out whether one was affected?


Thanks,
Chris.

