Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaJVAzT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 20:55:19 -0400
Date: Tue, 21 Oct 2014 20:55:07 -0400
From: Dave Jones <davej@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [3.18rc1] btrfs triggering vm bug_on
Message-ID: <20141022005507.GA14508@redhat.com>
References: <20141021215731.GA10296@redhat.com>
 <5446FF71.7000606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5446FF71.7000606@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 22, 2014 at 08:50:57AM +0800, Qu Wenruo wrote:
 > Any reproducer?
 > 
 > Thanks,
 > Qu
 > -------- Original Message --------
 > Subject: [3.18rc1] btrfs triggering vm bug_on
 > From: Dave Jones <davej@redhat.com>
 > To: Linux Kernel <linux-kernel@vger.kernel.org>
 > Date: 2014年10月22日 05:57
 > > page:ffffea00088aa1c0 count:4 mapcount:0 mapping:ffff88009901e2d8 index:0x0
 > > flags: 0x2ffc0000000806(error|referenced|private)
 

Not easily. It had been running trinity for around 24hrs, and the
post-mortem file it dumped doesn't seem too helpful.

	Dave
