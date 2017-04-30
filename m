Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35027 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1949560AbdD3DKv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 23:10:51 -0400
Received: by mail-it0-f68.google.com with SMTP id 70so9492176ita.2
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 20:10:51 -0700 (PDT)
Received: from [192.168.0.23] ([98.4.97.1])
        by smtp.gmail.com with ESMTPSA id p3sm4643636ioi.20.2017.04.29.20.10.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Apr 2017 20:10:49 -0700 (PDT)
Message-ID: <590555B8.3070006@gmail.com>
Date: Sat, 29 Apr 2017 23:10:48 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: ERROR: cannot find parent subvolume, can't see reason for it.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to do a "send -p src/snp1 src/snp2 dst/" and getting the 
following error:

ERROR: cannot find parent subvolume

The "src/snp1" is present in both "src/" and "dst/".   The "src/snp2" is 
present in "src/" .
The send works when "-p" is not used, but will not work when it is.

I imagine I am missing something obvious but cannot see what, and would 
appreciate some suggestions on what might be causing the error.

note: I have sent several queries to this list, but have not heard 
anything back.   I hope they have not been inappropriate.  If so, I 
would be grateful if you would let me know, or if there is somewhere 
else I should be going for advice.

I have had pretty good luck with the basics of btrfs and have high hopes 
for it.  I do seem to be having some difficulty getting much beyond 
basic functionality with small flat filesystem layouts, and will soon 
have to revert back to ext4 for some of the more complex functionality I 
made use of under that.   I look forward to seeing what further progress 
might be had with btrfs, and hope to be able to use it in a few years time.

