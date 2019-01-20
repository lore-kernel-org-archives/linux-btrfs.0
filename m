Return-Path: <SRS0=8/Zd=P4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEA8C6369F
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 14:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D2102087B
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 14:08:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xsv6JJby"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbfATOEH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Jan 2019 09:04:07 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:46425 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfATOEG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Jan 2019 09:04:06 -0500
Received: by mail-lj1-f172.google.com with SMTP id v15-v6so15284074ljh.13
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2019 06:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bnM8w1BKxT7P+CK5QNkxRUcKvIn4F/9+Mies4dR80Iw=;
        b=Xsv6JJbyatckJAkbkEk/t8wZKI+jOC8AxhQ53hngMpOnb0vE5aZu8m/V/y5v13tRDn
         Iuj3zX9W2p0TCQXNYt+VJfFPwznNKtyc317mXGtJ5ihmNTt88gJpo65YEQV7DAoov8jD
         EzNvK0Phn2UgrHQ7KK/PjrqCCCFICHYJWWGEuQMyFL3FYIthw3JvSIzSrLIyxgbtHwOW
         Fis4NxmP65FH68BB+REI8fMRR5GZOQK4yHkvbkW4xVHCLgeR2KhMWrc/sH6hn0lq/L3e
         Z8gG3y7Ak7EEDxdiIGp65MuquqyDKyHQzJs6MVPTka9KF7BUwHT3qgICrB53EehjG5Hc
         NU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bnM8w1BKxT7P+CK5QNkxRUcKvIn4F/9+Mies4dR80Iw=;
        b=YnroA3oNbgX2ToRRog9mpfUTAl9J6Vspcddsub2ZAR1p4hZk0mLdUFilyb57KdlIWe
         hewjQpce1hNfvRNwMC7/TdaUaF6m0mkuVWd/EE+Lw1/AEu06MuMr3ym8d4G7Bpw5pwKY
         jWWQb4okOBn25F8bBV760PdiV68nfTNhR0qTUdv+ZB6u3ywY7/LdrsehO2VR17anBmsL
         0OxiBY85iTQmhHX2Al8EvbSDoJiOJSe112M22BMkKCN72JoNHw4cWIxmwWvtvEg/xcHH
         aXYuQ8xf7Mbi8dYY/rhH2C4IFr1HgsfwSu+2//0sQg3eO7zm8zb+4uA8Vmmc/FD9yVIi
         rEqw==
X-Gm-Message-State: AJcUukf3+++tl17zYze5wtUG52Q+oCKVz4EEACadg7CNZwq9Xm6hsO6u
        QfYG8YkLDKyJ/qembbmzTlAFuu/O
X-Google-Smtp-Source: ALg8bN73iqHVLVrPW3Hiy4fSF8dGbacjHzWVDIaaJZ7PfUfmrWWZSC0ReGqVdAqt9phItLnhYP5ZLQ==
X-Received: by 2002:a2e:9d17:: with SMTP id t23-v6mr15596401lji.57.1547993043316;
        Sun, 20 Jan 2019 06:04:03 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id x29-v6sm1735679ljb.97.2019.01.20.06.04.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 06:04:02 -0800 (PST)
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Dennis K <dennisk@netspace.net.au>, linux-btrfs@vger.kernel.org
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBDxiRwwRBAC3CN9wdwpVEqUGmSoqF8tWVIT4P/bLCSZLkinSZ2drsblKpdG7x+guxwts
 +LgI8qjf/q5Lah1TwOqzDvjHYJ1wbBauxZ03nDzSLUhD4Ms1IsqlIwyTLumQs4vcQdvLxjFs
 G70aDglgUSBogtaIEsiYZXl4X0j3L9fVstuz4/wXtwCg1cN/yv/eBC0tkcM1nsJXQrC5Ay8D
 /1aA5qPticLBpmEBxqkf0EMHuzyrFlqVw1tUjZ+Ep2LMlem8malPvfdZKEZ71W1a/XbRn8FE
 SOp0tUa5GwdoDXgEp1CJUn+WLurR0KPDf01E4j/PHHAoABgrqcOTcIVoNpv2gNiBySVsNGzF
 XTeY/Yd6vQclkqjBYONGN3r9R8bWA/0Y1j4XK61qjowRk3Iy8sBggM3PmmNRUJYgroerpcAr
 2byz6wTsb3U7OzUZ1Llgisk5Qum0RN77m3I37FXlIhCmSEY7KZVzGNW3blugLHcfw/HuCB7R
 1w5qiLWKK6eCQHL+BZwiU8hX3dtTq9d7WhRW5nsVPEaPqudQfMSi/Ux1kc0mQW5kcmVpIEJv
 cnplbmtvdiA8YXJ2aWRqYWFyQGdtYWlsLmNvbT7CZQQTEQIAJQIbAwYLCQgHAwIGFQgCCQoL
 BBYCAwECHgECF4AFAliWAiQCGQEACgkQR6LMutpd94wFGwCeNuQnMDxve/Fo3EvYIkAOn+zE
 21cAnRCQTXd1hTgcRHfpArEd/Rcb5+SczsBNBDxiRyQQBACQtME33UHfFOCApLki4kLFrIw1
 5A5asua10jm5It+hxzI9jDR9/bNEKDTKSciHnM7aRUggLwTt+6CXkMy8an+tVqGL/MvDc4/R
 KKlZxj39xP7wVXdt8y1ciY4ZqqZf3tmmSN9DlLcZJIOT82DaJZuvr7UJ7rLzBFbAUh4yRKaN
 nwADBwQAjNvMr/KBcGsV/UvxZSm/mdpvUPtcw9qmbxCrqFQoB6TmoZ7F6wp/rL3TkQ5UElPR
 gsG12+Dk9GgRhnnxTHCFgN1qTiZNX4YIFpNrd0au3W/Xko79L0c4/49ten5OrFI/psx53fhY
 vLYfkJnc62h8hiNeM6kqYa/x0BEddu92ZG7CRgQYEQIABgUCPGJHJAAKCRBHosy62l33jMhd
 AJ48P7WDvKLQQ5MKnn2D/TI337uA/gCgn5mnvm4SBctbhaSBgckRmgSxfwQ=
Message-ID: <bfdab6f0-e282-47b9-911b-30cee765d043@gmail.com>
Date:   Sun, 20 Jan 2019 17:04:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

20.01.2019 13:25, Dennis K пишет:
> Apologies in advance, if the issue I put forward is actually the
> intended behavior of BTRFS.
> 
> I have noted while playing with sub-volumes, and trying to determine
> what exactly are the requirements for a subvolume to act as a legitimate
> parent during a receive operation, that modification of one subvolume,
> can affect children subvolumes that are received.
> 
> It's possible I have noted this before when directories which I though
> should have existed in the destination volume, where not present,
> despite being present in the snapshot at the sending end.  (ie, a
> subvolume is sent incrementally, but the received subvolume is missing
> files that exist on the sent side).
> 
> I can replicate this as follows
> 
> Create the subvolumes and put some files in them.
> # btrfs sub create 1
> # btrfs sub create 2
> # cd 1
> # dd if=/dev/urandom bs=1M count=10 of=test
> # cd ..
> # btrfs sub snap 1 2

Apparently some command is missing here.

> # dd if=/dev/urandom bs=1M count=1 of=test2

This creates test2 outside of subvolumes 1 or 2.

> # cd ..
> 

And this goes one level up so that next commands are invalid (they
assume you are still in direct parent of 1 and 2).

Also I do not see what purpose your "btrfs sub snap" serves. It creates
snapshot 2/1, but it snapshot is not part of replication anyway.

> Now set as read-only to send.  Subvolume 1 has the file "test, and
> subvolume 2 has the files "test" and "test2".
> # btrfs prop set 1 ro true
> # btrfs prop set 2 ro true
> 
> Send, snapshot 2 is an incremental send.  The files created are the
> expected sizes.
> # btrfs send 1 -f /tmp/1
> # btrfs send -p 1 2 -f /tmp 2
> 

That must be a typo, from the following text /tmp/2 is implied. Never
manually type in commands; always copy and paste them (or record using
script or similar and attach exact recording). Otherwise nothing in your
report can be trusted.

> Now we make subvolume one read-write
> # btrfs prop set 1 ro false

At this point all bets are off.

> # rm 1/test
> 

Now subvolume 1 no more matches state that was used to generate
incremental stream.

> Delete subvolume 2 and then recreate it be receiving it.
> # btrfs sub del 2
> # btrfs receive -f /tmp/2 .
> 
> What happens, is that subvolume 2 is created, but it is missing the file
> 'test' which was present in subvolume 1 at the time it was created as a
> snapshot and sent.  It now only contains the file "test2", which is NOT
> the state that it was sent.
> 

That is correct. /tmp/2 contains just the *incremental* replication
stream, which contains instructions to apply changes in subvolume 2
against base subvolume 1. It does *not* contain full content of (replica
of) subvolume 2 because on receiving side btrfs would first have cloned
replica of subvolume 1 and then applied changes in replication stream.

> 
> Note the same results are obtained, if you also delete subvolume 1 and
> then recreate it with btrfs-receive.
> 
> This may explain why previously I found a send operation resulted in the
> receiving end missing files previously.
> 
> I understand that during send/receive, a snapshot is taken of the parent
> subvolume, then it is modified.  The problem is that if that snapshot is
> modified, then these modifications will affect the received subvolumes,
> including, in this case, silent data loss.
> 

Not sure I parse this part correctly, but in your case you intentionally
modified base subvolume and made btrfs apply changes to wrong initial
state. This is classical case of "doctor, it hurts when I stab myself in
the eye".

> 
> It would be better for the receive operation to fail, or at least put
> out a warning if the parent subvolume it is using has changed or is
> different from the reference subvolume used during send. 

I was honestly surprised that btrfs receive did not refuse to apply
changes to read-write subvolume. Otherwise replication stream normally
is applied in receiving side which simply does not have enough
information to check that *source* was not changed. Destination only
knows UUID of parent snapshot and assumes it was not changed.

Personally I consider ability to flip read-only bit major usability
issue which leads to problems you observed.

> I'm not sure
> whether BTRFS can check this via generation number or some other data,
> orbut at the moment, there is no such check and this appears to be a bug.
> 
> Is this correct behaviour?  Does BTRFS rely on the user, and user-space
> tools, never changing any subvolume in order to avoid silent data loss?
> 

Yes.
