Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41002 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755360AbcKWESq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 23:18:46 -0500
Subject: Re: [PATCH 6/9] btrfs: calculate end of bio offset properly
To: Christoph Hellwig <hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-7-git-send-email-hch@lst.de>
 <20161118200438.GF19038@vader.DHCP.thefacebook.com>
 <20161122094240.GA15407@lst.de>
 <20161122185842.GA17735@vader.DHCP.thefacebook.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d7a2fef2-900b-236d-8de7-b079b24869a5@oracle.com>
Date: Wed, 23 Nov 2016 12:21:41 +0800
MIME-Version: 1.0
In-Reply-To: <20161122185842.GA17735@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> Can anyone help me on how to get test coverage for the compression
>> code?
>
> I'm not surprised xfstests missed this one since it's just readahead.
> You might be able to get better coverage with
>
> export MOUNT_OPTS="-o compress-force"

  And where the data is /dev/urandom the btrfs compression will
  bail out, so xfstest cases which uses /dev/urandom won't test
  the compression code.
