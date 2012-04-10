From: "Fajar A. Nugraha" <list@fajar.net>
Subject: [PATCH] Snapper: Always create .snapshot dir unconditonally
Date: Tue, 10 Apr 2012 17:38:26 +0700
Message-ID: <CAG1y0sdSVvcSTNAbhUnC6MQSuKRUvQ4CTi8wLAcvXP-N_iJ1Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arvin Schnell <aschnell@suse.de>,
	"Matthias G. Eckermann" <mge@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Current version of snapper (commit 50dec40) bails out with this error
if .snapshots directory doesn't exist (as is the case on new snapper
install):

2012-04-10 16:15:30,241 ERROR libsnapper(17784)
Snapshot.cc(nextNumber):362 - mkdir failed errno:2 (No such file or
directory)

This patch tries to create .snapshots dir unconditionally.

Signed-off-by: Fajar A. Nugraha <github@fajar.net>
---
 snapper/Snapshot.cc |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/snapper/Snapshot.cc b/snapper/Snapshot.cc
index 8e9cc37..277fad7 100644
--- a/snapper/Snapshot.cc
+++ b/snapper/Snapshot.cc
@@ -353,6 +353,9 @@ namespace snapper
 	    if (snapper->getFilesystem()->checkSnapshot(num))
 		continue;

+	    // try to create .snapshots dir unconditionally
+	    mkdir(snapper->infosDir().c_str(), 0711);
+
 	    if (mkdir((snapper->infosDir() + "/" + decString(num)).c_str(),
0777) == 0)
 		break;

-- 
1.7.9.1
