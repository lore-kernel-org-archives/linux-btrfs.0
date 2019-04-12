Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D1DC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B20206BA
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:26:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zZQ93OGw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfDLN0o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:26:44 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45679 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfDLN0o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:26:44 -0400
Received: by mail-yw1-f68.google.com with SMTP id j128so3347745ywg.12
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 06:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6X1orjripbnsuW2TFbUEGysPtirwi/JG6j7ubHWL4ZU=;
        b=zZQ93OGwQLUR657qHXaLhQKBO4UK89ctvjNC8C7XevQv9R9BwyAdwDPNXD3luxvhEg
         ERuqpaakXxrL2K9S2tbGSfTOtiLBxSfaQXFwlpTOM14nQZXKgNYTy8XzdD05cnaCpu3Y
         j4jTnDVDoya0IDUM3eVOjkM6T9ZXthRrfIcKMycLo2YF456Xwkcw7C9xKfAlyvtWJq7C
         u5mL7LgWtgfDZK2OcCI52uRlCw2Js1RW4FJkd3sZdoqoKHdcr5HZkOW4giIave8uUBlC
         jEV+6az1D6hqzsnwQi0xqHvITBGAnvi950fUdLBj1WtSHYRGvvjKSTAPmQtsc6TeDFSG
         bBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6X1orjripbnsuW2TFbUEGysPtirwi/JG6j7ubHWL4ZU=;
        b=AVEEaHj4T6AvaC/HxMvzRWI7uPKCzrmDQEDfuM9j+g40B8IiuIU5t5EXXJ0npu2Q+D
         6Ug/zcnKqN8MXIKnl8UQmVIn4+TfgQ8V8bdZaTeM9T0tnMEYnJblyQS+dLzqv35omB3M
         mbO7aCrEoJBNGWYabXesnnLpNHJXEPzX8Ymdb/795KaB+HIYO2VvENHx7vwB+wfL7qD6
         jt3d5kC7rcROTtbYoyDDgrv81FIfZYf3nuSHDg7K7VjHdU8d1WaxWj8tn970auK9vIIP
         FczBVzpnOajREkxwPad5tdqI7l74VU/0CaR1NyAXVD2d7MyYsgVqd+Lhwr5yl4+UK7Lc
         Fn8w==
X-Gm-Message-State: APjAAAWBQG6r3Is02TTqCwb20dKBnayA2JtceLVna9HicVegqvztbC2D
        0MhyIVIvL8CmlrORE+97GsNG0Gi19uV+Ow==
X-Google-Smtp-Source: APXvYqzm+0Pxuo28reMXV6undciNgfgQp2WX6uPn5t/THPLkZetVDcyX8lfjeLaM0BP7Cvc1ktrJmA==
X-Received: by 2002:a0d:cb0b:: with SMTP id n11mr45120269ywd.452.1555075602987;
        Fri, 12 Apr 2019 06:26:42 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::d607])
        by smtp.gmail.com with ESMTPSA id p2sm18545318ywp.53.2019.04.12.06.26.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 06:26:42 -0700 (PDT)
Date:   Fri, 12 Apr 2019 09:26:41 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: reserve delalloc metadata differently
Message-ID: <20190412132639.2be46k54avhiwlcb@macbook-pro-91.dhcp.thefacebook.com>
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-3-josef@toxicpanda.com>
 <0098847c-71fb-b305-3f2a-392ce2737ed4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0098847c-71fb-b305-3f2a-392ce2737ed4@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 12, 2019 at 04:06:25PM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
> > With the per-inode block rsvs we started refilling the reserve based on
> > the calculated size of the outstanding csum bytes and extents for the
> > inode, including the amount we were adding with the new operation.
> > 
> > However generic/224 exposed a problem with this approach.  With 1000
> > files all writing at the same time we ended up with a bunch of bytes
> > being reserved but unusable.
> > 
> > When you write to a file we reserve space for the csum leaves for those
> > bytes, the number of extent items required to cover those bytes, and a
> > single credit for updating the inode at ordered extent finish for that
> > range of bytes.  This is held until the ordered extent finishes and we
> > release all of the reserved space.
> > 
> > If a second write comes in at this point we would add a single
> > reservation for the new outstanding extent and however many reservations
> > for the csum leaves.  
> 
> If a second write comes we won't do anything different than the first
> i.e calculate the number of extent items + csums bytes required, add
> them to the block reservation and call btrfs_inode_rsv_refill which
> should refill the delta necessary for the 2nd write.
> 
> 
> At this point we find the delta of how much we
> > have reserved and how much outstanding size this is and attempt to
> > reserve this delta.  If the first write finishes it will not release any
> > space, because the space it had reserved for the initial write is still
> > needed for the second write.  However some space would have been used,
> 
> Each and every reservation is responsible for itself how come the first
> one will know some of its space is required for the second, hence it
> won't be released?
> 

Write 1 comes in, sets the size to 3mib, reserves 3mib.
Write 2 comes in, sets the size to 5 mib, attempts to reserve 2mib.
  - can't reserve because there's not enough space, starts flushing.
Write 1 finishes, used 1mib of it's 3mib reservation
Write 1 sets the size to 3mib
We still have 2mib in reserves, which is less than 3mib, so no bytes are
  released to the space info.

Now multiply this by 1000, you have 1000 files with 2mib sitting in their
reservations, but they need 2mib, and there's no space to be squeezed from the
rest of the fs, so they start to ENOSPC out one by one.

With the new thing we get this

Write 1 comes in, reserves 3mib, sets the size to 3mib.
Write 2 comes in, attempts to reserve 3mib.
  - can't reserve because there's not enough space, starts flushing.
Write 1 finishes, used 1mib of it's 3mib reservation
Write 1 sets the size to 0mib
Write 1 releases 2mib to the space_info, allowing the next waiter to claim 2mib
  of whatever it's reservation was.

Multiply this by 1000.  As we get smaller and smaller amounts of metadata space
to work with, we get less and less writes happening in parallel, because we only
have X inodes worth of reservations to be in flight at any given time.  Thanks,

Josef
