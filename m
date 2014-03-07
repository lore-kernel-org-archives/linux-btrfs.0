Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49207 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbaCGNjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 08:39:39 -0500
Message-ID: <5319CCE2.3040503@fb.com>
Date: Fri, 7 Mar 2014 08:42:58 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Daniel J Blueman <daniel@quora.org>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.13.5 btrfs read() oops
References: <CAMVG2stsU-5QpEKXT4qGLMqdW0TFZWeTEkJTZgFayqv-HOwuYg@mail.gmail.com>
In-Reply-To: <CAMVG2stsU-5QpEKXT4qGLMqdW0TFZWeTEkJTZgFayqv-HOwuYg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/07/2014 05:55 AM, Daniel J Blueman wrote:
> With kernel 3.13.5 (Ubuntu mainline), when plugging in a (evidently
> twitchy) USB3 stick with a BTRFS filesystem, I hit an oops in read()
> [1].
> 
> Full dmesg output is at:
> https://urldefense.proofpoint.com/v1/url?u=http://quora.org/2014/btrfs-oops.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=l%2B%2Fvx4VlYB25NI5yUJbBz2UM5ao0KdYuSUnSSAQ4pmY%3D%0A&s=0eee1e5d23ceb6100beb27d5a4f2e050d241e6b53e0db678e81ba9c8b88ad351

I've just uploaded a for-stable-3.13 branch that should fix this:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-stable-3.13

-chris
