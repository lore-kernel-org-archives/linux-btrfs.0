Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33128 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaIBX00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 19:26:26 -0400
Received: by mail-pa0-f49.google.com with SMTP id kq14so15720912pab.22
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 16:26:25 -0700 (PDT)
Message-ID: <5406521E.9090006@converseincode.com>
Date: Tue, 02 Sep 2014 16:26:22 -0700
From: Behan Webster <behanw@converseincode.com>
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>, agk@redhat.com, clm@fb.com,
        davem@davemloft.net, dm-devel@redhat.com, fabf@skynet.be,
        herbert@gondor.apana.org.au, jbacik@fb.com, snitzer@redhat.com
CC: akpm@linux-foundation.org, james.l.morris@oracle.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-security-module@vger.kernel.org, neilb@suse.de, serge@hallyn.com,
        torvalds@linux-foundation.org,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH RFC 5/6] apparmor: LLVMLinux: Remove VLAIS
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com> <1409697153-7006-6-git-send-email-behanw@converseincode.com> <54064FD1.6060900@canonical.com>
In-Reply-To: <54064FD1.6060900@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/14 16:16, John Johansen wrote:
>
> I'm fine with this, do you want me to pull it into my tree for our next push
> or do you want this all to go together as a set?
>
> Acked-by: John Johansen <john.johansen@canonical.com>
I'm more than happy for individual maintainers to pull relevant patches 
into their trees for the next merge window.

They were presented as a RFC patch set purely to get consensus as a 
group since its the same change across the board.

Happy to push your patch to you now.

Behan

-- 
Behan Webster
behanw@converseincode.com

