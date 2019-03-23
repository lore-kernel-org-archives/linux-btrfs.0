Return-Path: <SRS0=xp1I=R2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181B7C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 09:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB705218D4
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 09:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L/5scTTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfCWJMg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Mar 2019 05:12:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37733 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCWJMf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Mar 2019 05:12:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id 8so3116657pfr.4;
        Sat, 23 Mar 2019 02:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vUzKH7sN5kgpY2+5dtMlgK45TAYAXRpt9c7IFBZPhjI=;
        b=L/5scTTHFF72+pOU0/+c61AKLTEqR++/6jwv80FGomveKZ/YKfrbBgSqXTFFbpJKBo
         vQNphi7QBnDVMH3cSXBq72mQOCkrBDS5ArJ2PWTBtVpunA/w6Or2Rp6Ly9/LEjj4enBT
         m1372GULLjoWK6fpBcdU5+gcQkta5NLvsJPfMURBkpWWAVmGaQC6QrQeIUGYbIST91kW
         yTOzrtKbbqj5m4vDuvCXIXO+X2eym9HJI8AJzGA1hDweyVpXTth6Jlh1vj0OnwhRd27D
         RDisg5pnTejVGzXl9w9kgAvTE+TSyddWxRPSiMA5A/Pxlkp6pvxKZHav1UTyic2vnbo5
         clbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vUzKH7sN5kgpY2+5dtMlgK45TAYAXRpt9c7IFBZPhjI=;
        b=iN7Zpf0o7ehhZ1Zu9ZNKV6V3aVj3AOG7fn5cjLEIOLTJFngQdIw2GASNIPhmfOj5oZ
         1lTuDcdn8dFK/a1y5JIoVSL/HHBmzV+X+HHY3bdQzLfYaqfyoHof4r/hXvbSgCOvRC2N
         qr1/XWm/9lzF/SMFnx6nltPkj/kUMr5Weo9vlyMFgGY0LjDgW0SfbnfZ0wO7dDe0c89F
         GY3LXpfXs3+tBvZSbnzDnmszgi+2wRiSwTss0Thk+mz2CdBsNjqR/9FSKER91oP+c/Ox
         LD5/WSOtBjSqzfK53ubwiEyCLw7BCc/Qns2n20Nzc6WpMw7nMAEMe0u/lmCmiTOne49Y
         5NRg==
X-Gm-Message-State: APjAAAUE+HEg4T4IzXGB26hgrVjEiJEUhYmgj4EDJs4ns0/bkEtGQsyr
        GJBK+2wk2BRxm/QC74l2dnbFAYng0wo=
X-Google-Smtp-Source: APXvYqwlYBtxwPXPpLr9QzRNcyfUvO36/eenLFMfFsCUpiQEpB+JR2bUsotZhsOHH/bPTsJHRnESOQ==
X-Received: by 2002:a63:195f:: with SMTP id 31mr2451566pgz.116.1553332355083;
        Sat, 23 Mar 2019 02:12:35 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id h184sm23916196pfc.78.2019.03.23.02.12.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Mar 2019 02:12:34 -0700 (PDT)
Date:   Sat, 23 Mar 2019 17:12:27 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Extend btrfs/003 device removal test
Message-ID: <20190323091227.GU2824@desktop>
References: <20190319110404.9707-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319110404.9707-1-nborisov@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 01:04:04PM +0200, Nikolay Borisov wrote:
> When a device is deleted/removed from a btrfs filesystem the kernel
> ensures all superblocks on said device are zeroed out. Test for this
> behavior. Since btrfs inspect-internal dump-super always return success
> I cannot test for the return value of the command. Instead there are 2
> cases to handle:
> 
>     1. When the device is smaller than the requested super block copy, i.e.
>     super block copy 2 resides at 256GB. In such cases btrfs command just
>     returns blank screen
> 
>     2. When the device is removed and a valid offset of the super block is
>     queried btrfs command returns a textual error to stderr.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I think this test deserves a new test itself, not being embedded in an
existing test randomly.

Thanks,
Eryu

> ---
> V2: 
> 	* properly assign the return value of the last command expression to ret
> 
>  tests/btrfs/003 | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index 22aa57aad0b9..a805826ce891 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -161,6 +161,14 @@ _test_remove()
>  	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
>  	$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
>  	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del >> $seqres.full && _fail "btrfs still shows the deleted dev"
> +	for i in {0..2}; do
> +		local output=$($BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1)
> +		$BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1 | grep -q "bad magic"
> +		ret=$?
> +		if [[ "$output" != "" && $ret -eq 1 ]]; then
> +			_fail "Delete dev superblocks not scratched"
> +		fi
> +	done
>  	_scratch_unmount
>  }
>  
> -- 
> 2.7.4
> 
