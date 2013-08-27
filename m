Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab3H0VVi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 17:21:38 -0400
Message-ID: <521D184F.5060407@redhat.com>
Date: Tue, 27 Aug 2013 16:21:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <521CFDD8.6030205@suse.com> <20130827205637.GM29654@localhost.localdomain> <521D14FF.9090604@suse.com>
In-Reply-To: <521D14FF.9090604@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/27/13 4:07 PM, Jeff Mahoney wrote:
> On 8/27/13 4:56 PM, Josef Bacik wrote:
>> On Tue, Aug 27, 2013 at 03:28:24PM -0400, Jeff Mahoney wrote:
>>> On 8/26/13 4:56 PM, Josef Bacik wrote:
>>>> One of the complaints we get a lot is how many BUG_ON()'s we have.  So to help
>>>> with this I'm introducing a kconfig option to enable/disable a new ASSERT()
>>>> mechanism much like what XFS does.  This will allow us developers to still get
>>>> our nice panics but allow users/distros to compile them out.  With this we can
>>>> go through and convert any BUG_ON()'s that we have to catch actual programming
>>>> mistakes to the new ASSERT() and then fix everybody else to return errors.  This
>>>> will also allow developers to leave sanity checks in their new code to make sure
>>>> we don't trip over problems while testing stuff and vetting new features.
>>>> Thanks,
>>>
>>> I don't think the complaint is so much about the number of BUG_ONs, but
>>> that there's no distinction between something that is supposed to be
>>> impossible and something that is improbable. The BUG_ONs to keep code
>>> correctness are good and are littered all over the kernel with positive
>>> results. The BUG_ONs that are there in place of real error handling
>>> served their purpose and need to be replaced.
>>>
>>> So, I don't know if it's a net win to compile the "good" BUG_ONs out of
>>> the code. Especially if a user runs into something strange yet familiar
>>> and the first response is "oh, huh, can you rebuild with asserts enabled?"
>>>
>>
>> Either I provide an option for it or distros do it themselves, this cuts out the
>> middle man.  I'd really rather they just be on all the time since they aren't
>> things we should hit anyway, but at least this way people have a choice.
> 
> Ok. With my distro hat on, I can tell you I'll be leaving them on. :)
> 
> -Jeff

XFS also has XFS_WARN as a config option, which keeps all the assertions
in place, but printk's & backtraces w/o the icky BUG().  That might be
good to add as well, and perhaps best for a shipping distro (vs. a developer
debugging who might want to drop a core file when the assert trips).

- -Eric

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSHRhOAAoJECCuFpLhPd7gYbcP/034ADG3dwTa83FaAWuAurg7
byKWG4EwRqt3PYjUgruxBJAc426O7tz6j1NNTrAwZys9/GJOsisPShA8gO0f+W/A
+bQZJlXoUMbbwVPMcCqsnKMKlXNyKoqgME9AUQOrzMB/SgDtC9Y/OgdqgWF/58UV
X1KC3OOtcfQr/1t19AZuNhJ5oHfytoscv3nnnW5872t1JtL8daomak4fyDuRKgRV
45kQ726nafUlXNmi1TG8GadlcmKxxbBm0vt2ui6RtZWVauPE4Gej+iEUux9WtwSc
48eOQ5iqbFVzC8v++Rc1eT28mBIjSetr+O/Tk+VL4TvYCKA2trMAltNAFinv9AB0
Q+Z9F1K26aFe/Z/gcM57j+c0VOkv1tvSElF1iJcVHPuRvV7k+548g+KVzbXNDPBP
vuV2fnUCpw/XHQlrI+efYLs7Ies0TuV2eGPhmbKWjhossPwOeng71zxuiXSbNMBE
gVcHg6idXjCdaCCIYuJr8+5K4ngnpTEbAUs4C2x6iHzuHZcXScEHWYU/nHvizElL
bCZ162QSeQZAd+NgSzoZSmv4XqFMj6c4q60XvhAuu3fpkVPVY4GshcFhT14Onhfl
/054HqdQIXjUGOdbeuUwmXoaqzpSKDhBmZ0G+ykarD1KRCaEW61JrnFepRPO7G69
Q3oiPIbvdvCw3BZAJaGL
=7vvX
-----END PGP SIGNATURE-----
