Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF341C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 12:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DAB2064C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 12:07:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6DAB2064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbeJaVFc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 17:05:32 -0400
Received: from smtp02.belwue.de ([129.143.71.87]:53648 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbeJaVFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 17:05:32 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id D470665F9
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 13:07:44 +0100 (MET)
Date:   Wed, 31 Oct 2018 13:07:44 +0100
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Understanding "btrfs filesystem usage"
Message-ID: <20181031120744.GA4990@rus.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20181029181141.GA31256@rus.uni-stuttgart.de>
 <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
 <20181030161003.GA25765@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030161003.GA25765@rus.uni-stuttgart.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue 2018-10-30 (17:10), Ulli Horlacher wrote:
> 
> On Mon 2018-10-29 (17:57), Remi Gauvin wrote:
> 
> > On 2018-10-29 02:11 PM, Ulli Horlacher wrote:
> > 
> > > I want to know how many free space is left and have problems in
> > > interpreting the output of: 
> > > 
> > > btrfs filesystem usage
> > > btrfs filesystem df
> > > btrfs filesystem show
> > 
> > In my not so humble opinion, the filesystem usage command has the
> > easiest to understand output.  It' lays out all the pertinent information.
> > 
> > You can clearly see 825GiB is allocated, with 494GiB used, therefore,
> > filesystem show is actually using the "Allocated" value as "Used".
> > Allocated can be thought of "Reserved For".
> 
> And what is "Device unallocated"? Not reserved?

The answer is in the FAQ and I am stupid not to looked at it, first :-}

https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_free_space_do_I_have.3F


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20181030161003.GA25765@rus.uni-stuttgart.de>
