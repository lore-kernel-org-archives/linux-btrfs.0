Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7767C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 09:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7916320870
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 09:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553507360;
	bh=Oal7flNQwT9u03yT3aAACwafEYYaGm4K4yZxV7zkB6g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=DwKki74vNxPxOpmlPMj2xQFRlduziK8fNlvkOyMizKckLxOF9Nu78e4SrTI+HFecG
	 VhBLsRXihSbvMcInTgFSbMi5kps8983K3MjUybUT6ib82wvuO5b8ZxgeqxYe+pLjvI
	 EyUKUy8tttuY9kHZK7qn1yTnIOzPbrsR8rAIWXgU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbfCYJtO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:49:14 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43281 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730354AbfCYJtN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 05:49:13 -0400
Received: by mail-oi1-f194.google.com with SMTP id 67so6387940oif.10;
        Mon, 25 Mar 2019 02:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oal7flNQwT9u03yT3aAACwafEYYaGm4K4yZxV7zkB6g=;
        b=FhD6nSp2ggaC+i/1W1I+REYtXoWG9ZHbZpVyTNcRrnXnB7Z0ohiSraB+LKQhUzfQbc
         eBfCe/TzqQWoSiJEvhqzLl/a7GYWdvJpK+Z8GOBpOHLHQzrg2Z3+freA9jpWjt3Xcdkj
         CfkbKxeHTLskvLo3ze4PJtMDaTHn72I2LJG83VJnOt4v9bHTQPjJ85YtnSf3ufMDx1Kb
         Ix2RC2Dc6g61vUBdbOq0wiUtK0b039ijxHGknZ2cM1mOhoMNPUe6LWmz8lLeBP09vcL/
         LBCMztWvBv7LjQLjjtr6SfzgDylWg2WX4TpxH3vT0Cea2j+cZJ0il8mzvRU5Wv8pm0jM
         ynrg==
X-Gm-Message-State: APjAAAVA3Xta7/2mG01L9NwAfzG2s+QUNEV09Ll+Ds33lAq1IkPVDg0A
        64/GzIzZJHkXYnQjHyIWOYGqlPV2tgG6cQiBZ14=
X-Google-Smtp-Source: APXvYqzJNFY+7ARxSB+4c0sPo+9Jc49EQ+AENFDT1Rq9ALKT80u54QwmuukEqifSZ5X/P4w7O9C0yhDGnkFMiwI6NzM=
X-Received: by 2002:aca:eb93:: with SMTP id j141mr11026445oih.178.1553507352232;
 Mon, 25 Mar 2019 02:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <20190322132108.25501-3-sakari.ailus@linux.intel.com> <CAJZ5v0i8JiQGk25yZKQqTzCCY+nrfoKXOH8nM6eNPhkN-i+y9w@mail.gmail.com>
In-Reply-To: <CAJZ5v0i8JiQGk25yZKQqTzCCY+nrfoKXOH8nM6eNPhkN-i+y9w@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 25 Mar 2019 10:49:01 +0100
Message-ID: <CAJZ5v0ixukjWzSUqNCOpYuQci=7+ctdEhdZwOh=afz1b2zFVaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] vsprintf: Remove support for %pF and %pf in favour of
 %pS and %ps
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        xen-devel@lists.xenproject.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Linux Memory Management List <linux-mm@kvack.org>,
        ceph-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 10:30 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Fri, Mar 22, 2019 at 2:21 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> >
> > %pS and %ps are now the preferred conversion specifiers to print function
> > %names. The functionality is equivalent; remove the old, deprecated %pF
> > %and %pf support.
>
> Are %pF and %pf really not used any more in the kernel?
>
> If that is not the case, you need to convert the remaining users of
> them to using %ps or %pS before making support for them go away
> completely.

Well, this is a [2/2] in a series, sorry for the noise (/me blames
gmail for the confusion).
