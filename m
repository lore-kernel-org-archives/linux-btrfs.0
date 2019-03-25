Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B826C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752D7206DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfCYWip (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:38:45 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:50867 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfCYWip (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 18:38:45 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1h8YEs-0000aV-5p; Mon, 25 Mar 2019 22:38:42 +0000
Date:   Mon, 25 Mar 2019 22:38:42 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: parent transid verify failed / FS wont mount / help please!
Message-ID: <20190325223842.GC27856@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 25, 2019 at 10:26:29PM +0000, berodual_xyz wrote:
> Dear all,
> 
> on a large btrfs based filesystem (multi-device raid0 - all devices okay, nodatacow,nodatasum...) 

   Ouch. I think the only thing you could have done to make the FS
more fragile is mounting with nobarrier(*). Frankly, anything you're
getting off it is a bonus. RAID-0 gives you no duplicate copy,
nodatacow implies nodatasum, and nodatasum doesn't even give you the
ability to *detect* data corruption, let alone fix it.

   With that configuration, I'd say pretty much by definition the
contents of the FS are considered to be discardable.

   Restoring from backups is the recommended approach with transid
failures.

(*) Don't do that.

> I experienced severe filesystem corruption, most likely due to a hard reset with inflight data.
> The system cannot mount (also not with "ro,nologreplay" / "nospace_cache" etc.).

   Given how close the transids are, have you tried
"ro,usebackuproot"? That's about your only other option at this
point. But, if btrfs restore isn't working, then usebacuproot probably
won't either.

> Running "btrfs restore" I got a reasonable amount of data backed up, but a large chunk is missing.
> 
> "btrfs check" gives the following error:
> 
> ##
> $ btrfs check -b /dev/sdd
> Opening filesystem to check...
> parent transid verify failed on 1048576 wanted 60234 found 60230
> parent transid verify failed on 1048576 wanted 60234 found 60230
> Ignoring transid failure
> parent transid verify failed on 55432763981824 wanted 60233 found 60235
> parent transid verify failed on 55432763981824 wanted 60233 found 60235
> Ignoring transid failure
> parent transid verify failed on 55432753725440 wanted 60232 found 60235
> parent transid verify failed on 55432753725440 wanted 60232 found 60235
> Ignoring transid failure
> parent transid verify failed on 55432764063744 wanted 60233 found 60235
> parent transid verify failed on 55432764063744 wanted 60233 found 60235
> Ignoring transid failure
> Checking filesystem on /dev/sdd
> UUID: 8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
> [1/7] checking root items
> Error: could not find extent items for root 268
> ERROR: failed to repair root items: No such file or directory
> ##
> 
> I have a complete "dump tree" zip but its a couple of GB.
> 
> Some sources on the net say to run "btrfs check --init-extent-tree" but I would like to reach out first.

   Probably not wise. "Sources on the net" are frequently wrong when
it comes to btrfs recovery.

> btrfs progs version is 4.20.2 and kernel is 4.20.17

   At least those aren't out of date. The only positive thing here...

   Hugo.

-- 
Hugo Mills             | I gave up smoking, drinking and sex once. It was the
hugo@... carfax.org.uk | scariest 20 minutes of my life.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcmVhxAAoJEFheFHXiqx3kYzQP/2yi7FpJdCMvnqszURX+AnE4
2Me/W7jMQOn6cjadshXYNNfSImnEnmKo8Bhf99R4AMFWxiv7If7xxX/5Rhx+GZI9
JZU9QVrzGVg1Z0h9leCKOZ7s4Dz96vTJCcKcz2jcCEzmiMWJVvV0iamlecbVuG76
VK0DA7BTUE+yqdTOdpm74+55sapcwK6nXdMJ+8GjQvY8r/yBanzhbNCh3FKaWpl2
00WW7kIZTEnVKkaQO533foq4uDiH5JqepwfwrJyi7QALh1EtDh9QtcaMreKZ9MCd
w1KV3cuB/iV0+IMhoufba6JMjk12X/EOV3j/qFfiKqe6638hp8oQovIJSN1dhxe8
GZxVOgYpdAA+T8sN8y6IiGyvejJnogDRrjWr4igpD9bIX9aUFUiBHuT89s7p1cR7
gwXpai7HuNvdlk1Ml3oDgeggLf0iodsUGcaztx/tAguLbsKH+UdttOmtSe0+gw9k
rdKMt5HUT+cQ9GU/RU4AATqTWkJn2+QX+EtMun4OVej81MoO7fmWCR30LRXBLpuG
i9OC97GCnq3A8gXkDqEGNqZ/KlfuRJVhAIvBvyGMCq6VufGxdsu1nAJwoqc1r9w8
+Wu7wb9UDNxdRqQvTDzg8dT1d90wHlyW4AwF54AnFELkRNVCbLJmf0+NLdWNvG8i
In0q07Y5IEgGUdJQQTo8
=a7Qw
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
