Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26827 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbaCLPZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 11:25:38 -0400
Message-ID: <53207C4B.6020000@fb.com>
Date: Wed, 12 Mar 2014 11:24:59 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>, Zach Brown <zab@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>	<20140307002549.GC16439@lenny.home.zabbo.net> <CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
In-Reply-To: <CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/12/2014 08:56 AM, Rich Freeman wrote:
> On Thu, Mar 6, 2014 at 7:25 PM, Zach Brown <zab@redhat.com> wrote:
>> On Thu, Mar 06, 2014 at 07:01:07PM -0500, Josef Bacik wrote:
>>> Zach found this deadlock that would happen like this
>>> 
>> 
>> And this fixes it.  It's run through a few times successfully.
> 
> I'm not sure if my issue is related to this or not - happy to start
> a new thread if not.  I applied this patch as I was running into
> locks, but I am still having them.
> 
> See:
> https://urldefense.proofpoint.com/v1/url?u=http://picpaste.com/IMG_20140312_072458-KPH35pQ6.jpg&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=i0z2iBhr7rZW%2Bkc1oo9FXeEzYukWs4Q36PGBkcCzub4%3D%0A&s=a3430d4f9555ea4c4ae32e4570a75bb66153a7d4b76e99e46da7e7c3d2a80a2e
>
>  After a number of reboots the system became stable, presumably 
> whatever race condition btrfs was hitting followed a favorable
> path.
> 
> I do have a 2GB btrfs-image pre-dating my application of this
> patch that was causing the issue last week.
> 

Uhm wow that's pretty epic.  I will talk to chris and figure out how
we want to deal with that and send you a patch shortly.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTIHxGAAoJEANb+wAKly3BNMYP/0HYjAVhf9NndNM/ZsLcR48k
4Br0S3QPuNuMvyZMtTSmpSWmLjhtPOl87llOSBfYOTti3AVXYuyzHruGxpkjrqAS
PLYF+1wlrJeJ7FO6of7B0ZTzbEZcpMOV5Y0FV5m2ONGO1HthLISVTipVgm9KIcWG
wa1BmyqdVg2h2aRmBeFTJVHWWHCK3m2qLXiNpiH3Vh399vZwrdh7tmVI3Pvv+nVj
NGl+xskoaQHV9TUz4RnpyQ2dg/y3A+f+GmbDHcI3WUi/6is1Pnctv0RrGb1XYwlu
DuhYxP/vbrgD9PE4C3/6kaXMfnzVkqQk9dN6hqWZnOq5Vo1zbTeEpemvDvRPRYVf
PwJ29PXXRJsUtHpr68/xBAjBE2elLQvnIHOkfqVSsTNKA4PZzojcw7k0WIFTRveN
iWDDGqcL+Pnvq9Ajj8hjlnVIqQwExx5K0Bikue/Nr8p3vuy1FEvdOXlxmOqPVd6K
Bw2H9mPsJeLHZdwV3Kb0aH3rA8ruPqZHy3Dp0/r0gcYKwpQTKv5cDnjhu5aJ4xgZ
k7Ve8AFZwqChnXPdr9yZr1dBrxBTVa7b/uY+7PiAQQiBXa5M2yZOP9R3H+yak1PP
w11FNrhemaKpYX63Equ9VVRDv0TFIslklLfvVRIQIUKpZ+4XX43hmU0EqYbbN+Eh
fGiSsK1fFbWt/js23RoD
=sGCH
-----END PGP SIGNATURE-----
