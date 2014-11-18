Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:57251 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaKRU65 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 15:58:57 -0500
Received: by mail-qg0-f47.google.com with SMTP id z60so5250055qgd.34
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 12:58:56 -0800 (PST)
Message-ID: <546BB2EA.5080809@ubuntu.com>
Date: Tue, 18 Nov 2014 15:58:18 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org> <47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
In-Reply-To: <47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 1:57 PM, Chris Murphy wrote:
> So a.) use smartctl -l scterc to change the value below 30 seconds 
> (300 deciseconds) with 70 deciseconds being reasonable. If the
> drive doesn’t support SCT commands, then b.) change the linux scsi
> command timer to be greater than 120 seconds.
> 
> Strictly speaking the command timer would be set to a value that 
> ensures there are no link reset messages in dmesg, that it’s long 
> enough that the drive itself times out and actually reports a read 
> error. This could be much shorter than 120 seconds. I don’t know
> if there are any consumer drives that try longer than 2 minutes to 
> recover data from a marginally bad sector.

Are there really any that take longer than 30 seconds?  That's enough
time for thousands of retries.  If it can't be read after a dozen
tries, it ain't never gonna work.  It seems absurd that a drive would
keep trying for so long.

> Ideally though, don’t use drives that lack SCT support in multiple 
> device volume configurations. An up to 2 minute hang of the
> storage stack isn’t production compatible for most workflows.

Wasn't there an early failure flag that md ( and therefore, btrfs when
doing raid ) sets so the scsi stack doesn't bother with recovery
attempts and just fails the request?  Thus if the drive takes longer
than the scsi_timeout, the failure would be reported to btrfs, which
then can recover using the other copy, write it back to the bad drive,
and hopefully that fixes it?

In that case, you probably want to lower the timeout so that the
recover kicks in sooner instead of hanging your IO stack for 30 seconds.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUa7LqAAoJEI5FoCIzSKrw2Y0H/3Q03vCTxXeGkqvOYG/arZgk
yHq/ruWIKMgfaESdu0Ujzoqbe7XopUueU8luKon52LtbgIFhOM5XnMu/o52KPXIS
CVLnNtRWNbykHJMQu0Sk4lpPrUVI5QP9Ya9ZGVFM4x2ehvJGDAT+wcRWP5OH0waf
mgK+oOnadsckqiSbcQhGrxecjTWZFu5WUCzWFPx+4sEV5ta/tmL0obhHcyho+SDN
lCib2KI9YGzS2sm+V/Qe2i/3ZMp8QY8aAD2x/KlV0DBxkRLZQdOoD3ZkBiaApxZX
VMfXNCKLMexwpe+rGGemH/fCvhRpM/z1aHu8D1u4QVnoWPzD51vX7ySLkwRHaGo=
=XZkM
-----END PGP SIGNATURE-----
