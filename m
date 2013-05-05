Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38867 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3EEJsU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 05:48:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYvYJ-0005wv-2Q
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 11:48:19 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 11:48:19 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 11:48:19 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: exploit preload daemon to defragment most needed files
Date: Sun, 05 May 2013 11:42:24 +0200
Message-ID: <05mh5a-iqe.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart5351348.zuBQ37VPXV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart5351348.zuBQ37VPXV
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit

Hey list,

Although this is about the preload daemon, my intended audience for this 
matter is the btrfs community. So I'm posting this here.

I've created a small script here[1] to read the preload daemon state file 
and use this to run the btrfs defragmenter/compressor on these files. The 
idea was to have some proof-of-concept to maybe integrate defragmentation 
capabilities directly into preload.

While I'd like to read some feedback from the community, maybe collect some 
more ideas, I already discovered one drawback which is a show-stopper: btrfs 
won't defragment files currently in use (probably memory-mapped files only 
but these are a lot while a desktop env is running). I didn't look into it 
any closer yet. And I didn't run benchmarks. But my first impressions are 
that preloading is a bit faster and less io-intensive.

Regards,
Kai

[1]: https://gist.github.com/kakra/5520200
--nextPart5351348.zuBQ37VPXV
Content-Type: application/x-ruby; name="defrag-preloaded.rb"
Content-Disposition: attachment; filename="defrag-preloaded.rb"
Content-Transfer-Encoding: base64

IyEvYmluL2VudiBydWJ5CiMKIyBiYXNpYyBjb25jZXB0IHNjcmlwdCBmb3IgZGVmcmFnbWVudGlu
ZyBmaWxlcyBvbiBidHJmcyBsb2FkZWQgYnkgcHJlbG9hZCBkYWVtb24KIwojIEF1dGhvcjogS2Fp
IEtyYWtvdyA8aHVyaWtoYW43N0BnbWFpbC5jb20+CiMgTGljZW5zZTogR1BMMwoKZmlsZV9hbHJl
YWR5X3F1ZXVlZCA9IHt9CgpJTy5wb3BlbigneGFyZ3MgLS1uby1ydW4taWYtZW1wdHkgLS1tYXgt
YXJncz0yMCAtLW1heC1wcm9jcz0zIC0tbnVsbCBidHJmcyBmaWxlc3lzdGVtIGRlZnJhZ21lbnQg
LXYgLWNsem8nLCAndycpIGRvIHx4YXJnc3wKCiAgRmlsZS5mb3JlYWNoKCcvdmFyL2xpYi9wcmVs
b2FkL3ByZWxvYWQuc3RhdGUnKSBkbyB8bGluZXwKICAgIG5leHQgdW5sZXNzICVye14oRVhFfE1B
UClccy4qP2ZpbGU6Ly8oLiopfSA9fiBsaW5lCiAgICBuZXh0IGlmIGZpbGVfYWxyZWFkeV9xdWV1
ZWRbbmFtZSA9ICQyXQoKICAgIGlmIEZpbGUuZXhpc3RzPyhuYW1lKQogICAgICB4YXJncy5wcmlu
dCAiI3tuYW1lfVwwIgogICAgICBmaWxlX2FscmVhZHlfcXVldWVkW25hbWVdID0gdHJ1ZQogICAg
ZW5kCiAgZW5kCgogIHhhcmdzLmZsdXNoCgplbmQK

--nextPart5351348.zuBQ37VPXV--


