Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E51C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 23:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A04542084C
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 23:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfDBXXj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 19:23:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:33900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfDBXXi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 19:23:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C68ABAF42;
        Tue,  2 Apr 2019 23:23:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B7DAFDA824; Wed,  3 Apr 2019 01:24:47 +0200 (CEST)
Date:   Wed, 3 Apr 2019 01:24:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4 RESEND] btrfs: open code btrfs_set_prop in
 inherit_prop
Message-ID: <20190402232447.GK29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-5-anand.jain@oracle.com>
 <8fedbab1-6fec-92cb-25b2-c9b9ff264103@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fedbab1-6fec-92cb-25b2-c9b9ff264103@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 04:35:12PM +0300, Nikolay Borisov wrote:
> > @@ -367,20 +367,35 @@ static int inherit_props(struct btrfs_trans_handle *trans,
> >  		if (!value)
> >  			continue;
> >  
> > +		/* may be removed */
> 
> This comment brings no value. Either explain *why* it can be removed or
> remove it altogether.

Comment replaced by 

                 /*                                                                                                                                                                                               
                  * This is not strictly necessary as the property should be                                                                                                                                      
                  * valid, but in case it isn't, don't propagate it futher.                                                                                                                                       
                  */

I'd keep it the because that's what the direct opencoding transformation would
do. If we want to remove it, then the reasoning should be provided.
