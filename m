Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34269 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbbJILOm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Oct 2015 07:14:42 -0400
Received: by iow1 with SMTP id 1so87922791iow.1
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2015 04:14:42 -0700 (PDT)
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
To: Hugo Mills <hugo@carfax.org.uk>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        linux-btrfs@vger.kernel.org
References: <201510052226.47051.pisa@cmp.felk.cvut.cz>
 <561657D5.1070809@gmail.com> <20151008211352.GC25907@carfax.org.uk>
 <201510090016.43759.pisa@cmp.felk.cvut.cz>
 <20151008222223.GD25907@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5617A175.9080300@gmail.com>
Date: Fri, 9 Oct 2015 07:13:57 -0400
MIME-Version: 1.0
In-Reply-To: <20151008222223.GD25907@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020203080208090905050001"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020203080208090905050001
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-08 18:22, Hugo Mills wrote:
> On Fri, Oct 09, 2015 at 12:16:43AM +0200, Pavel Pisa wrote:
>> Hello Hugo,
>>
>> On Thursday 08 of October 2015 23:13:52 Hugo Mills wrote:
>>> On Thu, Oct 08, 2015 at 07:47:33AM -0400, Austin S Hemmelgarn wrote:
>>>> On 2015-10-08 04:28, Pavel Pisa wrote:
>>>>> I go to use "btrfs replace" because there has not been any reply to=
 my
>>>>> inplace correction question. But I expect that clarification if
>>>>> possible/how to resync RAID1 after one drive temporal disappear is
>>>>> really important to many of BTRFS users.
>>>>
>>>> As of right now, there is no way that I know of to safely re-sync a
>>>> drive that's been disconnected for a while.  The best bet is
>>>> probably to use replace, but for that to work reliably, you would
>>>> need to tell it to ignore the now stale drive when trying to read
>>>> each chunk.
>>>
>>>     Scrub is officially what you need there. I can confirm that it
>>> works correctly, having used it myself after accidentally unplugging
>>> the wrong drive.
>>>
>>
>> Thanks for the reply.
>>
>> I have tried to run scrub after reconnect but it counted errors in
>> its console output and write errors has been logged by kernel as crazy=
=2E
>> I have to admit I have not wait to finish it because I have not good
>> feeling from it.
>
>     If the scrub works OK, you will still get lots of scary-looking
> errors in the logs, but they'll usually say it's repaired the problem.
>
>     Getting write errors at this point indicates that you have hardware=

> problems of some kind, and (usually) that device needs to be replaced.
> (Or the controller, or the cabling).
>
>> May it be it was result of not fully correct reconnect.
>> But other partition worked with ext4 has no problems to write.
>>
>> But if mount/unmount (in my case requiring reboot) and then scrub
>> worked it would be much simpler than replaces series.
>>
>> I hope I would not need that (at least soon/in years) but I
>> give try to scrub again.
>>
>> May it be problem is my btrfs tools old version on the server --
>> Wheezy Btrfs v3.17 backport. Kernel is Linux 4.1.2 #1 SMP PREEMPT.
>
>     No, the version of the tools has no effect on any of this. It
> really sounds like you have hardware issues.
I have to agree with Hugo here, it really sounds like you have hardware=20
issues.  If the new HDD doesn't completely fix things, try replacing the =

cabling (because that's the easy to fix without spending a lot of money, =

and having spare cables is usually a good thing), then try the=20
controller or RAM.



--------------ms020203080208090905050001
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA5MTExMzU3WjBPBgkq
hkiG9w0BCQQxQgRAmMU5+ZV5Hw57nmS2np7BeW3AxdBVGWPjkrSkl7TddjQrpQscS4K2I5hI
SakHd/HtX0FDAFoJutT2ff0VD7FZejBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAQWwf2hKi01Y+5vXeWXAE7iZH9T415VHndhy8m7bqsQ0wrvpMK
zTWRZAr6eQcubLkxYUhMQ3ma9m/D/gIHZYC/+jiDvMUiq8y8t8d/Go0DbsmCe1mI5i7X7qak
GTX8leY6QY20Anx9m+ytYCQuoTCwlJ15Q+Vf2qzypNZLGwVofWUxYx/kv4ZKmC2LZtW7ojZ2
b+1kR7seOa623SeSskdGzg5g9Mwpx8ofj7pnL84xiY4BpfdMCW823+6GiIcKADce24VnY4xw
qJzyPb7dRZaxb8RzG/DnW3XzQ0ExfaCGDZpgaUZZBGmw81epQdppkEVKhRn/WPyOThvtGLWN
bbQzVgDKtVtNCWm2Ju29O3Qr2JmTfVDg3QKnWi0qgGMmmDRP9fcw/ZrN0UqKIsbMmL7BVNUV
9Q+acigLv33JEgmW/5zbZwnQ0/2evIYTVG9S2+WrEzPgceDLEnAYKGq01CB04lWdxjM9GSI8
WkaobCTkbtzmVLUHgOQ5Qh1QBnu1mqxCsL0z+e++pKow0sddtNhb50nFL2BKJG5XnSzZHeDw
4eh50qY6pzzMNwcJxrQTMO6aKuE+M64BYLg3qbHEhQYssSlmlDEMCzf1DQ5NPVSvuE5yeUkI
ZDkoRsgJvHArVrDsbk/sQm5U76rlPVQq8/2hl/dYPc5gmZwAY4kYRY2p9QAAAAAAAA==
--------------ms020203080208090905050001--
