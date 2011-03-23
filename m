From: Karn Kallio <tierpluspluslists@gmail.com>
Subject: stratified B-trees
Date: Wed, 23 Mar 2011 12:08:52 -0430
Message-ID: <201103231208.52592.tierpluspluslists@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I just noticed this out today on the arXiv : http://xxx.lanl.gov/abs/1103.4282 
The paper describes "stratified B-trees" and quoting from the abstract:

"
We describe the `stratified B-tree', which beats the CoW B-tree in every way. 
In particular, it is the first versioned dictionary to achieve optimal 
tradeoffs between space, query and update performance. Therefore, we believe 
there is no longer a good reason to use CoW B-trees for versioned data stores.
"

The paper mentions that a company called "Acunu" is developing an 
implementation.  

Are these stratified B-trees something which the btrfs project could use?
