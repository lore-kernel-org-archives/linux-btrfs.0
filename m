Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:61030 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaBSNIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 08:08:05 -0500
Received: from [131.220.3.232] (hocheck.informatik.uni-bonn.de [131.220.3.232])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 8CBDE5C404
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 13:59:19 +0100 (MET)
	(envelope-from ochmann@informatik.uni-bonn.de)
	(envelope-to linux-btrfs@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
Message-ID: <5304AA69.5020800@informatik.uni-bonn.de>
Date: Wed, 19 Feb 2014 13:58:17 +0100
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Meaning of "no_csum" field when scrubbing with -R option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I have a question: What exactly does the value for "no_csum" mean when 
doing a scrub with the -R option? Example output:


 > sudo btrfs scrub start -BR /

scrub done for ...
   ...
   csum_errors: 0
   verify_errors: 0
   no_csum: 70517
   csum_discards: 87381
   super_errors: 0
   ...


In the btrfs header, I found the following comment for the "no_csum" 
field of the btrfs_scrub_progress struct:


"# of 4k data block for which no csum is present, probably the result of 
data written with nodatasum"


So my question is, why does scrub show a high (i.e. non-zero) value for 
no_csum? I never enabled nodatasum or a similar option.

Best regards
Sebastian
