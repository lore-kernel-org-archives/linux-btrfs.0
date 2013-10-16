Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30091 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3JPCOb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 22:14:31 -0400
Message-ID: <525DF851.2020205@oracle.com>
Date: Wed, 16 Oct 2013 10:22:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] btrfs-progs: add more parameter to the filesystem
 show
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com> <1381203700-17558-2-git-send-email-anand.jain@oracle.com> <20131015172236.GN5787@twin.jikos.cz>
In-Reply-To: <20131015172236.GN5787@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> preview as below..
>>
>> Label: none  uuid: 26d539a5-8968-4cf0-b4b5-5fd50105f8a0 mounted: /btrfs
>> 	Group profile: Metadata: single  Metadata: DUP  Data: single
>
> It would look better if the profile types are grouped together,

  As of now mkfs.btrfs and balance don't agree on the same set
  of default group profiles. When we fix mkfs.btrfs (and for
  now when user run balance) we won't see multiple profile for
  Metadata/Data. So grouping them isn't needed, rather we should
  fix mkfs and balance to be inline.
  For now (in the FS which contains some data) after the balance
  we won't see multiple group-profile for same group-type.

  pls comment / let me know.

> otherwise it can drift to the right quite far.

  as of now do we practicality use/support multiple groups
  for the same type (metadata/data), if not the content will
  be always 6 words here (I am considering a system which is
  balanced).

> Why is Sytem not listed here?

  System is not an user choice (?), So users won't be keen to
  know at least in this high-level display. IMO.

Thanks, Anand

