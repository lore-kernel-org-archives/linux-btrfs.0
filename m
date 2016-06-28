Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:55181 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbcF1M4o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 08:56:44 -0400
Received: from [77.13.67.154] (helo=hermione.invalid)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1bHsZE-00038v-BA
	for linux-btrfs@vger.kernel.org; Tue, 28 Jun 2016 14:56:40 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1bHsZD-0002ug-Qc
	for linux-btrfs@vger.kernel.org; Tue, 28 Jun 2016 14:56:39 +0200
Date: Tue, 28 Jun 2016 14:56:39 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Bug in 'btrfs filesystem du' ?
Message-ID: <20160628125639.GA6997@invalid>
References: <20160627132841.GA11661@invalid>
 <20160627133310.GB11661@invalid>
 <CAPmG0jbcojqdERe39Fnu20mg2e2VyxJOUi53Zy6kV_=B=q-zEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jbcojqdERe39Fnu20mg2e2VyxJOUi53Zy6kV_=B=q-zEA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Am Montag, den 27. Juni schrieb Henk Slager:
> On Mon, Jun 27, 2016 at 3:33 PM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
> > Am Montag, den 27. Juni schrieb M G Berberich:
> >> after a balance ‘btrfs filesystem du’ probably shows false data about
> >> shared data.
> >
> > Oh, I forgot: I have btrfs-progs v4.5.2 and kernel 4.6.2.
> 
> With  btrfs-progs v4.6.1 and kernel 4.7-rc5, the numbers are correct
> about shared data.

I tested with kernels 4.6.3 and 4.7-rc5 and with btrfs-progs 4.5.2 and
4.61. The later kernel with two patches to make the kernel work:
https://lkml.org/lkml/2016/6/1/310 https://lkml.org/lkml/2016/6/1/311 .

You can see the script¹ I used (do-btrfs-du-test) and the logs at
http://m-berberich.de/btrfs/

In all four cases, ‘btrfs fi du -s .’ reports

     Total   Exclusive  Set shared  Filename
  59.38MiB       0.00B    29.69MiB  .

befor balance and

     Total   Exclusive  Set shared  Filename
  59.38MiB    59.38MiB       0.00B  .

after balance.

Disclaimer: The script works for me, no guaranty at all.

	MfG
	bmg
__________
¹ Disclaimer: The script works for me, no guaranty at all.
-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
