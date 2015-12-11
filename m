Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbbLKXOv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 18:14:51 -0500
Subject: Re: attacking btrfs filesystems via UUID collisions?
To: Christoph Anton Mitterer <fo@fo>, Chris Murphy <lists@colorremedies.com>,
        "S.J." <sorry@anonym.com>
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <566B58E9.7030101@redhat.com>
Date: Fri, 11 Dec 2015 17:14:49 -0600
MIME-Version: 1.0
In-Reply-To: <1449872498.31388.74.camel@fo>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/15 4:21 PM, Christoph Anton Mitterer wrote:
>>  Note that Btrfs is
>> > not unique, XFS v5 does a very similar thing with volume UUID as
>> > well,
>> > and resulted in this change:
>> > http://oss.sgi.com/pipermail/xfs/2015-April/041267.html
> Do you mean that xfs may suffer from the same issues that we're talking
> about here? If so, one should probably give them a notice.

That was disabled temporarily because changing the fs UUID meant that
every piece of checksummed metadata with an embedded UUID would then
mismatch.

It was fixed (re-allowed) with

ce748ea xfs: create new metadata UUID field and incompat flag

in the kernel and

9c4e12f xfsprogs: Add new sb_meta_uuid field, update userspace tools to manipulate it

in xfsprogs. 

-Eric
