Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33357 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbcCCB7B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 20:59:01 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Cc: clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D79A5D.8070000@oracle.com>
Date: Thu, 3 Mar 2016 09:58:53 +0800
MIME-Version: 1.0
In-Reply-To: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




. (I received couple of private emails on this, so looks like
  I confused you and I'm writing again to clear the air on this).

> - Uses btrfs compression framework, so compression and then
>    encryption is not possible. However yet evaluate if there
>    are encryption algorithm which can compress as well.

  It should be compression and then encryption. I didn't mean to say
  the other way around. However the btrfs encoding framework is
  designed to handle any one of it in an elegant manner. So as of
  user can configure either encryption OR compression by design.

  Further for users who are looking for both compression and encryption.
  There are two ways that we could implement in future in the btrfs.
  One enhance the btrfs encoding framework so that it can accommodate
  two cascaded engines like compression and followed by encryption.
  Or (mostly) a better approach would be to evaluate a single encoding
  engine (algorithm) which can do both (compression and then encryption).
  Which I think will be less invasive within btrfs, and probably be more
  efficient.

  Hope I sound clearer now. Sorry if I wasn't before.



. I have put up a doc here:

https://docs.google.com/document/d/1fq9snDM_4ikn44UDNErjHqKXgZHukiJWS4Il3qVhm3M/edit?usp=sharing

For your kind review and suggestions.



Thanks, Anand
