Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36840 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbbKWQzt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 11:55:49 -0500
Received: by iofh3 with SMTP id h3so193714908iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 08:55:49 -0800 (PST)
Subject: Re: [PATCH v2 3/5] btrfs-progs: kernel based default features for
 mkfs
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <1448283378-10579-4-git-send-email-anand.jain@oracle.com>
 <1448294271.2100.3.camel@scientia.net> <56533951.7090208@gmail.com>
 <1448295247.2100.7.camel@scientia.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56534511.9050909@gmail.com>
Date: Mon, 23 Nov 2015 11:55:45 -0500
MIME-Version: 1.0
In-Reply-To: <1448295247.2100.7.camel@scientia.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010000030205040005020604"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010000030205040005020604
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-23 11:14, Christoph Anton Mitterer wrote:
> On Mon, 2015-11-23 at 11:05 -0500, Austin S Hemmelgarn wrote:
>> I would find it useful if btrfs gives a warning if it creates a
>>> filesystem which (because unsupported in the current kernel) lacks
>>> features which are considered default by then.
>> It should give a warning if the user requests a feature that is
>> unsupported by the kernel it's being run on, but it should not by
>> default try to enable something that isn't supported by the kernel
>> it's
>> running on.
> Well that as well, and of course it shouldn't try to enable a feature
> that wouldn't work, but what I meant was, e.g. if I create a fs with
> btrfs-progs 4.3 (where skinny-extents are default) but on such an old
> kernel where this isn't supported yet,... it should tell me "Normally
> I'd create the fs with skinny-extents, but I don't as your kernel is
> too old".
Ah, I misunderstood your meaning, that would be nice to have.
>> It is actually possible to clone a btrfs filesystem, just not in a
>> way
>> that people used to stuff like ext4 would recognize.  In essence, you
>> need to take the FS mostly off-line, force all subvolumes to read-
>> only,
>> then use send-receive to transfer things, and finally make the
>> subvolumes writable again.  I've been considering doing a script to
>> do
>> this automatically, but have never gotten around to it as it's not
>> something that is quick to code, and it's not something I do very
>> often.
> And that would also keep all ref-links, etc.? I.e. the copied fs
> wouldn't eat up much more space than the original?
> Well than such script should be part of btrfs-progs :-)
There's no way to reliably preserve _all_ ref-links, but between=20
snapshots and the subvolumes they are snapshots of, it should, assuming=20
that you either send them all at once (which would take a long time=20
probably), or that you do proper incremental transfers.  The other=20
disadvantage is that it may not (depending on the features of course)=20
cause any new features to be used except on new files.



--------------ms010000030205040005020604
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIzMTY1NTQ1WjBPBgkq
hkiG9w0BCQQxQgRAA/WQCDkPjSsHb74aw+X2TRPTcy5PvhaU9tZY6u5ga4WDQnxG2FD5Ply0
ubIcKkepszcZIgO0qBgG3pQ76Y1GiTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCMtfycTFe3Ya8uyoXsECUqEY5h7Hi2rI9vLr2g5dOAL1M5A1Rh
Sk/AQQHtYFWpUx0F1gFQNoiFwaHciMc7jjq/BNfQhQFQ2BYd5QDhrW2EG/lI00HfPUAcqaMQ
ib4i+CRwy3Uchc80WWVySlbl40KvP3Vm4bo4yVPMD9TMQJ3ZGE3+9ZHxxmlv4E2x9zAdv1uB
nyu9lfXppd9GHzYumH48ZGgfGB6orIKIl9dNz6gE2Wz7IxYSDMehiD6pU7nhbLnYJXc09cQl
NPoN8vSo4BE0caHJ8RLoTItL4nSPpfIMMZORei0mCAdvaF/TCaShniPGWaiKhfrnzjR3uRPo
Eu0B9NY1XYeK+XbOqkSbboAIpwaZq1oMG0O60deiSeMGef7Zd4f2pgHnoWRoWKb/WnaXAJnT
Q4Nj2jrfdj47AEbJp/yJJgtiKOOSBydYaty/NfaN2J0p8JGpq5BujIguVj38yWR0y9cGvjam
DjCrfvPU4WLthC06Rll6Ew7H3zZHLMCg0KWbZlbcV9SoFdrz0CFj62y7CzXi+L4R3+eCN/sS
0FEPlkp6VDao2cqFwj3C+hwGAPg4Z1KdwwF8UJ2qkb1uUh1U1RksaKXMDr7cz2zMSgsexmMW
OJvYgNXbs+exGTFMFvWa0KDQLH78ulkqOnJ1IFQ+vJ7wx4oRr1jkDyXVUwAAAAAAAA==
--------------ms010000030205040005020604--
