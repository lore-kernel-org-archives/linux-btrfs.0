Return-Path: <SRS0=YdAF=T7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEBEC04AB6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 11:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615CE25950
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 11:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaL1t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 May 2019 07:27:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:52338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbfEaL1t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 May 2019 07:27:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BA18AAA8
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2019 11:27:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BDE2FDA85E; Fri, 31 May 2019 13:28:41 +0200 (CEST)
Date:   Fri, 31 May 2019 13:28:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: switch extent_buffer spinning_writers from
 atomic to int
Message-ID: <20190531112841.GJ15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1559233731.git.dsterba@suse.com>
 <6dfcb89b254ee5016edfa9816fce3487a23b446c.1559233731.git.dsterba@suse.com>
 <41aca846-afb1-9b83-f442-d791eb929c36@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41aca846-afb1-9b83-f442-d791eb929c36@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 31, 2019 at 12:19:15PM +0300, Nikolay Borisov wrote:
> >  {
> > -	WARN_ON(atomic_read(&eb->spinning_writers));
> > -	atomic_inc(&eb->spinning_writers);
> > +	WARN_ON(eb->spinning_writers);
> > +	eb->spinning_writers++;
> >  }
> >  
> >  static void btrfs_assert_spinning_writers_put(struct extent_buffer *eb)
> >  {
> > -	WARN_ON(atomic_read(&eb->spinning_writers) != 1);
> > -	atomic_dec(&eb->spinning_writers);
> > +	WARN_ON(eb->spinning_writers != 1);
> > +	eb->spinning_writers--;
> >  }
> >  
> >  static void btrfs_assert_no_spinning_writers(struct extent_buffer *eb)
> >  {
> > -	WARN_ON(atomic_read(&eb->spinning_writers));
> > +	WARN_ON(eb->spinning_writers);
> >  }
> 
> IMO longterm  it will be good if those debug functions contained
> lockdep_assert_held_exclusive/read macros for posterity.

The functions are not public and used only inside implementation of
locks, so the chances of wrong use are low so I don't see much value
adding it.
