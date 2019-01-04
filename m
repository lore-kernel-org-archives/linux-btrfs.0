Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FA0C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 14:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B697206B6
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546610859;
	bh=ExxuOCcXTQGjhSiOhh9v2QogPHlkiDUMRzQitamlHxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DrdotsfbMnJXZrayHZ2zQNhZQ7pQvLLxFpo4Us8vOJfZdWwcg8Ot7kNuxWAwc+lV1
	 4wlmGmGl1qoFaCHnDMXGp7RzjO6ZXkgq3wKqG2Ns8Oc72U/l34DvteH02gZd5cf1qw
	 +2Ek0t54znk//4HmbdlvhzjN48DPOESbuzlr8/ZE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfADOHh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 09:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfADOHh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 09:07:37 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D99206B6;
        Fri,  4 Jan 2019 14:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546610857;
        bh=ExxuOCcXTQGjhSiOhh9v2QogPHlkiDUMRzQitamlHxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mfG4nbhi9cBWhHkwe3ZqJjGObGAMVfHqX4xXTSRXUCLi1EGmOv1cbPQ1zgeXJ5axf
         nnFWsckwGqrRwnDj5esHTHaiB1b41MCnfEKmp5IotBm7LwdYwDr6Y8sSokCP7VI78r
         2FYw8rcK2GNISlEfELUNaSzE2Q0BsZyoWUzciEt4=
Date:   Fri, 4 Jan 2019 15:07:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: no need to check return value of debugfs_create
 functions
Message-ID: <20190104140734.GA8970@kroah.com>
References: <20190104132520.GA22613@kroah.com>
 <a7d48bec-515c-164f-b5ee-1903ef98ef8d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7d48bec-515c-164f-b5ee-1903ef98ef8d@suse.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 03:36:59PM +0200, Nikolay Borisov wrote:
> 
> 
> On 4.01.19 г. 15:25 ч., Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Chris Mason <clm@fb.com>
> > Cc: Josef Bacik <josef@toxicpanda.com>
> > Cc: David Sterba <dsterba@suse.com>
> > Cc: linux-btrfs@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/btrfs/sysfs.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> > 
> > Meta-comment, why is there a btrfs debugfs directory at all?  All you
> > have here is a single "test" file that doesn't do anything except expose
> > a variable that never changes.  What is this directory and single file
> > for?  Can I just delete the whole thing?
> > 
> 
> git blame is your friend - 1bae30982bc8 ("btrfs: add simple debugfs
> interface")
> 
> 
> Apparently David had an idea to do something but it never materialized,
> imo the debugfs bits could be removed from sysfs.c

Ok, I'll gladly delete all of the code if the maintainers will accept
such a patch.

thanks,

greg k-h
